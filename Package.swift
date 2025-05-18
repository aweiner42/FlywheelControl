// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FlywheelControl",
    platforms: [
            .iOS("17.0.0"),
            .macOS(.v12)
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FlywheelControl",
            targets: ["FlywheelControl"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FlywheelControl"),
        .testTarget(
            name: "FlywheelControlTests",
            dependencies: ["FlywheelControl"]
        ),
    ]
)
