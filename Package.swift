// swift-tools-version: 5.7
import PackageDescription

let package = Package(
  name: "Slick",
  platforms: [
    .macOS(.v12)
  ],
  products: [
    .library(
      name: "Slick",
      targets: ["Slick"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    .package(url: "https://github.com/sindresorhus/ExceptionCatcher", from: "2.0.0")
  ],
  targets: [
    .target(
      name: "Slick",
      dependencies: [],
      path: "Slick"),
  ],
  swiftLanguageVersions: [.v5]
)
