import UIKit
import UniformTypeIdentifiers

/// "Tanooki Auth" in the share sheet for pictures: hands a QR code picture to the app, which reads it and asks
/// before adding anything. Big photos are shrunk first (a QR code reads fine at 2,000 pixels).
final class ShareViewController: UIViewController {
  private let label = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    label.numberOfLines = 0
    label.textAlignment = .center
    label.text = String(localized: "share.opening", defaultValue: "Opening Tanooki Auth…")
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      label.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
    ])
    Task { await handOver() }
  }

  private func handOver() async {
    let group = Bundle.main.object(forInfoDictionaryKey: "TAKeychainGroup") as? String
    guard let data = await loadImage(), SharedImage.save(data, group: group) == errSecSuccess else {
      return finish(String(localized: "share.failed", defaultValue: "Couldn't read that picture. Try a screenshot of the QR code."))
    }
    if await openApp() {
      extensionContext?.completeRequest(returningItems: nil)
    } else {
      finish(String(localized: "share.saved", defaultValue: "Got it. Open Tanooki Auth to add the account."))
    }
  }

  private func finish(_ message: String) {
    label.text = message
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
      self?.extensionContext?.completeRequest(returningItems: nil)
    }
  }

  private func loadImage() async -> Data? {
    let providers = (extensionContext?.inputItems as? [NSExtensionItem] ?? []).flatMap { $0.attachments ?? [] }
    guard let p = providers.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.image.identifier) }) else { return nil }
    let item = try? await p.loadItem(forTypeIdentifier: UTType.image.identifier)
    let image: UIImage?
    switch item {
    case let url as URL: image = (try? Data(contentsOf: url)).flatMap(UIImage.init(data:))
    case let data as Data: image = UIImage(data: data)
    case let img as UIImage: image = img
    default: image = nil
    }
    guard let image else { return nil }
    let longest = max(image.size.width * image.scale, image.size.height * image.scale)
    let scale = min(1, 2000 / max(longest, 1))
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    let size = CGSize(width: image.size.width * image.scale * scale, height: image.size.height * image.scale * scale)
    return UIGraphicsImageRenderer(size: size, format: format).pngData { _ in image.draw(in: CGRect(origin: .zero, size: size)) }
  }

  /// Share extensions can't call UIApplication.open directly; the app object is reached through the responder chain.
  @MainActor private func openApp() async -> Bool {
    guard let url = URL(string: "tanookiauth://image") else { return false }
    var responder: UIResponder? = self
    while let r = responder {
      if let app = r as? UIApplication {
        return await app.open(url)
      }
      responder = r.next
    }
    return false
  }
}
