// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FireworkVideoUI",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "FireworkVideoUI",
            targets: ["FireworkVideoUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/loopsocial/firework_ios_sdk.git", exact: Version("1.24.0-beta.2"))
    ],
    targets: [
        .target(
            name: "FireworkVideoUI",
            dependencies: [.product(name: "FireworkVideo", package: "firework_ios_sdk")]),
        .testTarget(
            name: "FireworkVideoUITests",
            dependencies: ["FireworkVideoUI"]),
    ]
)
