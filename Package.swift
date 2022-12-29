// swift-tools-version: 5.7
import PackageDescription

let package = Package(
  name: "Slick",
  platforms: [
    .macOS(.v10_15)
  ],
  products: [
    .library(
      name: "Slick",
      targets: ["Slick"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Slick",
      dependencies: [],
      path: "Slick"),
  ],
  swiftLanguageVersions: [.v5]
)
