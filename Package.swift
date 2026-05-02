// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "TapApplePayKit-iOS",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "TapApplePayKit-iOS",
            targets: ["TapApplePayKit-iOS"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Tap-Payments/CommonDataModelsKit-iOS.git", from: "1.0.149"),
        .package(url: "https://github.com/Tap-Payments/TapNetworkKit-iOS.git", from: "1.0.14"),
        .package(url: "https://github.com/Tap-Payments/TapApplicationV2.git", from: "0.0.3")
    ],
    targets: [
        .target(
            name: "TapApplePayKit-iOS",
            dependencies: [
                .product(name: "CommonDataModelsKit_iOS", package: "CommonDataModelsKit-iOS"),
                .product(name: "TapNetworkKit_iOS", package: "TapNetworkKit-iOS"),
                .product(name: "TapApplicationV2", package: "TapApplicationV2")
            ],
            path: "TapApplePayKit-iOS/Core",
            resources: [
                .process("Assets")
            ]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
