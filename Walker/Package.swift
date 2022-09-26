// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Walker",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "Walker",
            targets: ["Walker"]),
    ],
    dependencies: [
        .package(url: "https://github.com/archivable/package.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Walker",
            dependencies: [.product(name: "Archivable", package: "package")],
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Walker"],
            path: "Tests")
    ]
)
