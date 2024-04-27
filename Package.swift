// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OSlider",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
        .tvOS(.v14),
        .watchOS(.v7)
    ],
    products: [
        .library(name: "OSlider", targets: ["OSlider"]),
    ],
    targets: [
        .target(
            name: "OSlider",
            path: "Sources"
        ),
    ]
)
