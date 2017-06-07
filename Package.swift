// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "Runes",
  products: [
    .library(name: "Runes", targets: ["Runes"]),
  ],
  dependencies: [
    .package(url: "git@github.com:CodaFi/SwiftCheck.git", .branch("four-parts-unknown")),
    .package(url: "git@github.com:gfontenot/Mozart.git", .branch("swift-4")),
  ],
  targets: [
    .target(name: "Runes"),
    .testTarget(
      name: "RunesTests",
      dependencies: [
        "Runes",
        "SwiftCheck",
        "Mozart",
      ]
    ),
  ]
)
