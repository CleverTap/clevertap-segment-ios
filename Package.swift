// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Segment-CleverTap",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "Segment-CleverTap",
                 targets: ["Segment-CleverTap"]),
    ],
    dependencies: [
        .package(name: "Segment",
                 url: "https://github.com/segmentio/analytics-ios.git", from: "4.1.1"),
        .package(name: "CleverTapSDK",
                 url: "https://github.com/CleverTap/clevertap-ios-sdk.git", from: "3.10.0"),
    ],
    targets: [
        .target(
            name: "Segment-CleverTap",
            dependencies: [
                .product(name: "Segment", package: "Segment"),
                .product(name: "CleverTapSDK", package: "CleverTapSDK"),
            ],
            path: "Pod",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        )
    ]
)

