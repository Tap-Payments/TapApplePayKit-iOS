// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "TapApplePayKit-iOS",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "TapApplePayKit_iOS",
            targets: ["TapApplePayKit_iOS"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Tap-Payments/CommonDataModelsKit-iOS.git", from: "1.0.150"),
        .package(url: "https://github.com/Tap-Payments/TapNetworkKit-iOS.git", from: "1.0.18"),
        .package(url: "https://github.com/Tap-Payments/TapApplicationV2.git", from: "0.0.6")
    ],
    targets: [
        .target(
            name: "TapApplePayKit_iOS",
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
    swiftLanguageVersions: [.v5]
)
