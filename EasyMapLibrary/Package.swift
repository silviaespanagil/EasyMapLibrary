// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EasyMapLibrary",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "EasyMapLibrary",
            targets: ["EasyMapLibrary"]),
    ],
    targets: [
        .target(
            name: "EasyMapLibrary",
            dependencies: []),
        .testTarget(
            name: "EasyMapLibraryTests",
            dependencies: ["EasyMapLibrary"]),
    ]
)
