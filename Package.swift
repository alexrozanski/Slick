// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "slick",
  products: [
    .library(
      name: "slick",
      targets: ["slick"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "slick",
      dependencies: []),
  ]
)
