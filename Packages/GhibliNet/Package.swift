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
        .package(url: "https://github.com/kamaal111/ShrimpExtensions.git", from: "1.9.0"),
    ],
    targets: [
        .target(
            name: "GhibliNet",
            dependencies: ["ShrimpExtensions"],
            resources: [.process("Resources")]),
        .testTarget(
            name: "GhibliNetTests",
            dependencies: ["GhibliNet"]),
    ]
)
