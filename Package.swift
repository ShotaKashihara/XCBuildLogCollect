// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCBuildLogCollect",
    platforms: [.macOS(.v10_13)],
    products: [
        .executable(name: "xcbuildlogcollect", targets: ["XCBuildLogCollect"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/MobileNativeFoundation/XCLogParser.git", .exact("0.2.26")),
        .package(url: "https://github.com/googleapis/google-api-swift-client.git", branch: "master"),
        .package(url: "https://github.com/googleapis/google-auth-library-swift.git", branch: "master"),
    ],
    targets: [
        .executableTarget(
            name: "XCBuildLogCollect",
            dependencies: [
                "XCLogParser",
                "BigQueryClient",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .target(
            name: "BigQueryClient",
            dependencies: [
                .product(name: "GoogleAPIRuntime", package: "google-api-swift-client"),
                .product(name: "OAuth2", package: "google-auth-library-swift")
            ]),
        .testTarget(
            name: "XCBuildLogCollectTests",
            dependencies: ["XCBuildLogCollect"]),
    ]
)
