// tanooki/securitykey: YubiKey and other FIDO2 security keys (iOS, macOS), the native half of
// app/lib/core/security_key.dart.
//   available  "ok", or "osTooOld" (security-key PRF needs iOS / macOS 26.4).
//   register   {rp, userId, name, salt} -> {id, prf?}: makes a credential on the key, asking for its PRF output.
//   assert     {rp, ids, salt} -> {id, prf}: one of [ids] answers with its PRF output for [salt].
// Errors use the codes security_key.dart turns into sentences: canceled, notAllowed, notAssociated, exists, noPrf.
// Apple only lets an app use a relying party it's associated with (webcredentials:auth.tanookistudios.com).
import AuthenticationServices
import CryptoKit
import UserNotifications
#if os(iOS)
import Flutter
import UIKit
#else
import AppKit
import FlutterMacOS
#endif

final class SecurityKey: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  private var channel: FlutterMethodChannel?
  private var pending: FlutterResult?
  private var controller: ASAuthorizationController?

  static func register(with registrar: FlutterPluginRegistrar) {
    #if os(iOS)
    let messenger = registrar.messenger()
    #else
    let messenger = registrar.messenger
    #endif
    let instance = SecurityKey()
    let channel = FlutterMethodChannel(name: "tanooki/securitykey", binaryMessenger: messenger)
    instance.channel = channel
    channel.setMethodCallHandler(instance.handle)
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard #available(iOS 26.4, macOS 26.4, *) else {
      return result(call.method == "available" ? "osTooOld" : FlutterError(code: "osTooOld", message: nil, details: nil))
    }
    let args = call.arguments as? [String: Any] ?? [:]
    let rp = args["rp"] as? String ?? ""
    let salt = (args["salt"] as? FlutterStandardTypedData)?.data ?? Data()
    let provider = ASAuthorizationSecurityKeyPublicKeyCredentialProvider(relyingPartyIdentifier: rp)
    let prf = ASAuthorizationPublicKeyCredentialPRFAssertionInput.InputValues(saltInput1: salt)
    switch call.method {
    case "available":
      result("ok")
    case "register":
      let request = provider.createCredentialRegistrationRequest(
        challenge: Self.random(), displayName: args["name"] as? String ?? "Tanooki Auth",
        name: args["name"] as? String ?? "Tanooki Auth",
        userID: (args["userId"] as? FlutterStandardTypedData)?.data ?? Self.random())
      request.credentialParameters = [ASAuthorizationPublicKeyCredentialParameters(algorithm: .ES256)]
      request.residentKeyPreference = .discouraged // don't fill the key's small storage
      request.prf = .inputValues(prf)
      run(request, result)
    case "assert":
      let request = provider.createCredentialAssertionRequest(challenge: Self.random())
      let ids = (args["ids"] as? [FlutterStandardTypedData] ?? []).map(\.data)
      request.allowedCredentials = ids.map {
        ASAuthorizationSecurityKeyPublicKeyCredentialDescriptor(
          credentialID: $0, transports: ASAuthorizationSecurityKeyPublicKeyCredentialDescriptor.Transport.allSupported)
      }
      request.prf = .inputValues(prf)
      run(request, result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private static func random() -> Data { Data((0..<32).map { _ in UInt8.random(in: 0...255) }) }

  private func run(_ request: ASAuthorizationRequest, _ result: @escaping FlutterResult) {
    if pending != nil {
      return result(FlutterError(code: "busy", message: "Already waiting for a security key", details: nil))
    }
    pending = result
    let c = ASAuthorizationController(authorizationRequests: [request])
    c.delegate = self
    c.presentationContextProvider = self
    controller = c
    c.performRequests()
  }

  private func finish(_ value: Any?) {
    let r = pending
    pending = nil
    controller = nil
    r?(value)
  }

  private static func bytes(_ key: SymmetricKey?) -> FlutterStandardTypedData? {
    key.map { k in FlutterStandardTypedData(bytes: k.withUnsafeBytes { Data($0) }) }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    guard #available(iOS 26.4, macOS 26.4, *) else { return finish(FlutterError(code: "osTooOld", message: nil, details: nil)) }
    if let reg = authorization.credential as? ASAuthorizationSecurityKeyPublicKeyCredentialRegistration {
      if let out = reg.prf, !out.isSupported {
        return finish(FlutterError(code: "noPrf", message: nil, details: nil))
      }
      var reply: [String: Any] = ["id": FlutterStandardTypedData(bytes: reg.credentialID)]
      if let first = Self.bytes(reg.prf?.first) { reply["prf"] = first }
      finish(reply)
    } else if let a = authorization.credential as? ASAuthorizationSecurityKeyPublicKeyCredentialAssertion {
      var reply: [String: Any] = ["id": FlutterStandardTypedData(bytes: a.credentialID)]
      if let first = Self.bytes(a.prf?.first) { reply["prf"] = first }
      finish(reply)
    } else {
      finish(FlutterError(code: "failed", message: "Unexpected credential type", details: nil))
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    let e = error as NSError
    let code: String
    switch (e.domain, e.code) {
    case (ASAuthorizationError.errorDomain, ASAuthorizationError.Code.canceled.rawValue): code = "canceled"
    case (ASAuthorizationError.errorDomain, 1006): code = "exists" // matchedExcludedCredential (macOS 15 / iOS 18 name)
    case (ASAuthorizationError.errorDomain, _) where e.localizedDescription.localizedCaseInsensitiveContains("associated"):
      code = "notAssociated" // the app isn't linked to the relying party's domain yet
    case (ASAuthorizationError.errorDomain, ASAuthorizationError.Code.failed.rawValue): code = "notAllowed"
    default: code = "failed"
    }
    finish(FlutterError(code: code, message: e.localizedDescription, details: nil))
  }

  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    #if os(iOS)
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    return scenes.flatMap(\.windows).first(where: \.isKeyWindow) ?? scenes.first.map { UIWindow(windowScene: $0) } ?? UIWindow()
    #else
    return NSApp.keyWindow ?? NSApp.windows.first ?? NSWindow()
    #endif
  }
}

// tanooki/notify: the optional reminder on the 1st of each month that the monthly summary is ready (Premium).
//   scheduleMonthly {title, body}  asks for permission ("denied" if refused), then repeats on the 1st at 10:00.
//   cancelMonthly                  removes it.
final class MonthlyReminder: NSObject {
  static let id = "tanooki-monthly-summary"
  private var channel: FlutterMethodChannel?

  static func register(with registrar: FlutterPluginRegistrar) {
    #if os(iOS)
    let messenger = registrar.messenger()
    #else
    let messenger = registrar.messenger
    #endif
    let instance = MonthlyReminder()
    let channel = FlutterMethodChannel(name: "tanooki/notify", binaryMessenger: messenger)
    instance.channel = channel
    channel.setMethodCallHandler(instance.handle)
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let center = UNUserNotificationCenter.current()
    switch call.method {
    case "cancelMonthly":
      center.removePendingNotificationRequests(withIdentifiers: [Self.id])
      result(nil)
    case "scheduleMonthly":
      let args = call.arguments as? [String: Any] ?? [:]
      center.requestAuthorization(options: [.alert, .sound]) { granted, error in
        DispatchQueue.main.async {
          if let error { return result(FlutterError(code: "failed", message: error.localizedDescription, details: nil)) }
          if !granted { return result(FlutterError(code: "denied", message: nil, details: nil)) }
          let content = UNMutableNotificationContent()
          content.title = args["title"] as? String ?? "Tanooki Auth"
          content.body = args["body"] as? String ?? ""
          let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(day: 1, hour: 10), repeats: true)
          center.add(UNNotificationRequest(identifier: Self.id, content: content, trigger: trigger)) { error in
            DispatchQueue.main.async {
              result(error.map { FlutterError(code: "failed", message: $0.localizedDescription, details: nil) })
            }
          }
        }
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
