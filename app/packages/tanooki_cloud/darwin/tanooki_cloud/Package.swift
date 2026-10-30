// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "tanooki_cloud",
    platforms: [.iOS("15.0"), .macOS("12.0")],
    products: [.library(name: "tanooki-cloud", targets: ["tanooki_cloud"])],
    dependencies: [],
    targets: [.target(name: "tanooki_cloud", dependencies: [])]
)
