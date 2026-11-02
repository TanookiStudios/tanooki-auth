import AuthenticationServices
import SwiftUI

/// iPhone AutoFill for 2FA codes (iOS 18+). iOS calls in here when a website or app asks for a one-time
/// code: either for a suggestion shown above the keyboard (an account with that website), or to show our
/// list when the person picks Tanooki Auth themselves. Codes are worked out here from the copy the app
/// keeps in the shared keychain (Shared/AutoFill.swift); nothing leaves the iPhone.
final class CredentialProviderViewController: ASCredentialProviderViewController {
  private let group = Bundle.main.object(forInfoDictionaryKey: "TAKeychainGroup") as? String

  /// A suggestion above the keyboard was tapped. Plain accounts fill straight away; ask-first ones need
  /// Face ID, which iOS lets us ask for only in prepareInterfaceToProvideCredential.
  override func provideCredentialWithoutUserInteraction(for credentialRequest: any ASCredentialRequest) {
    guard let id = credentialRequest.credentialIdentity.recordIdentifier,
          let account = AutoFillStore.load(group: group).first(where: { $0.id == id })
    else { return fail(.credentialIdentityNotFound) }
    if account.requireAuth == true { return fail(.userInteractionRequired) }
    fill(account)
  }

  override func prepareInterfaceToProvideCredential(for credentialRequest: any ASCredentialRequest) {
    guard let id = credentialRequest.credentialIdentity.recordIdentifier else { return fail(.credentialIdentityNotFound) }
    fillAskFirst(id)
  }

  /// The person picked Tanooki Auth for a code box: accounts for this website or app first, then the rest.
  override func prepareOneTimeCodeCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
    let all = AutoFillStore.load(group: group)
    var sites: [String] = [], apps: [String] = []
    for s in serviceIdentifiers {
      if #available(iOS 26.2, *), s.type == .app {
        apps.append(s.identifier)
        if let name = s.displayName { apps.append(AutoFillMatch.squash(name)) }
      } else {
        sites.append(s.identifier)
      }
    }
    let matching = AutoFillMatch.ranked(all, sites: sites, appIDs: apps)
    let picker = AccountPicker(matching: matching, others: all.filter { !matching.contains($0) },
                               pick: { [weak self] in self?.pick($0) },
                               cancel: { [weak self] in self?.fail(.userCanceled) })
    let host = UIHostingController(rootView: picker)
    addChild(host)
    host.view.frame = view.bounds
    host.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(host.view)
    host.didMove(toParent: self)
  }

  /// Switched on in Settings: tell iOS which websites have codes, then close.
  override func prepareInterfaceForExtensionConfiguration() {
    AutoFillIdentities.publish(AutoFillStore.load(group: group))
    extensionContext.completeExtensionConfigurationRequest()
  }

  private func pick(_ account: AutoFillAccount) {
    account.requireAuth == true ? fillAskFirst(account.id) : fill(account)
  }

  /// Reading the ask-first copy makes iOS ask for Face ID or the passcode. Off the main thread, since
  /// the keychain waits for the person.
  private func fillAskFirst(_ id: String) {
    let group = self.group
    let prompt = String(localized: "Fill a code for an account that asks first")
    DispatchQueue.global(qos: .userInitiated).async {
      let account = AutoFillStore.loadAskFirst(group: group, prompt: prompt).first { $0.id == id }
      DispatchQueue.main.async { account.map(self.fill) ?? self.fail(.userCanceled) }
    }
  }

  private func fill(_ account: AutoFillAccount) {
    guard let code = account.code(at: Date()) else { return fail(.credentialIdentityNotFound) }
    extensionContext.completeOneTimeCodeRequest(using: ASOneTimeCodeCredential(code: code))
  }

  private func fail(_ code: ASExtensionError.Code) {
    extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: code.rawValue))
  }
}

/// The list shown when the person picks Tanooki Auth for a code box.
struct AccountPicker: View {
  let matching: [AutoFillAccount]
  let others: [AutoFillAccount]
  let pick: (AutoFillAccount) -> Void
  let cancel: () -> Void
  @State private var search = ""

  private func filtered(_ list: [AutoFillAccount]) -> [AutoFillAccount] {
    search.isEmpty ? list : list.filter { "\($0.issuer) \($0.label)".localizedCaseInsensitiveContains(search) }
  }

  var body: some View {
    NavigationStack {
      List {
        if matching.isEmpty && others.isEmpty {
          Text("No accounts to fill yet. In Tanooki Auth, open Settings and turn on Fill codes with AutoFill.")
            .foregroundStyle(.secondary)
        }
        if !filtered(matching).isEmpty {
          Section("For this website or app") { rows(filtered(matching)) }
        }
        if !filtered(others).isEmpty {
          Section(matching.isEmpty ? "Your accounts" : "Other accounts") { rows(filtered(others)) }
        }
      }
      .searchable(text: $search)
      .navigationTitle("Tanooki Auth")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) { Button("Cancel", action: cancel) }
      }
    }
  }

  private func rows(_ list: [AutoFillAccount]) -> some View {
    ForEach(list, id: \.id) { a in
      Button { pick(a) } label: {
        HStack {
          VStack(alignment: .leading) {
            Text(a.title).foregroundStyle(.primary)
            if !a.issuer.isEmpty && !a.label.isEmpty {
              Text(a.label).font(.caption).foregroundStyle(.secondary)
            }
          }
          Spacer()
          if a.requireAuth == true {
            Image(systemName: "lock.fill").foregroundStyle(.secondary).accessibilityLabel(Text("Asks first"))
          }
        }
      }
    }
  }
}
