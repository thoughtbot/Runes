// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "Runes",
  products: [
    .library(name: "Runes", targets: ["Runes"])
  ],
  dependencies: [
    .package(url: "git@github.com:CodaFi/SwiftCheck.git", .branch("fivel"))
  ],
  targets: [
    .target(name: "Runes"),
    .testTarget(
      name: "RunesTests",
      dependencies: [
        "Runes",
        "SwiftCheck",
      ]
    ),
  ]
)
