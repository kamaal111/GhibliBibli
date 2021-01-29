// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GhibliNet",
    products: [
        .library(
            name: "GhibliNet",
            targets: ["GhibliNet"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kamaal111/XiphiasNet.git", from: "3.0.5")
    ],
    targets: [
        .target(
            name: "GhibliNet",
            dependencies: ["XiphiasNet"],
            resources: [.process("Resources")]),
        .testTarget(
            name: "GhibliNetTests",
            dependencies: ["GhibliNet"]),
    ]
)
