// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCBuildLogCollect",
    platforms: [.macOS(.v10_13)],
    products: [
        .executable(name: "xcbuildlogcollect", targets: ["XCBuildLogCollect", "BigQuerySwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MobileNativeFoundation/XCLogParser", from: "0.2.28"),
        .package(url: "https://github.com/Kitura/SwiftyRequest.git", .upToNextMajor(from: "3.1.0")),
        .package(url: "https://github.com/ShotaKashihara/google-auth-library-swift.git", branch: "master"),
    ],
    targets: [
        .executableTarget(
            name: "XCBuildLogCollect",
            dependencies: ["XCLogParser", "BigQuerySwift"]),
        .target(
            name: "BigQuerySwift",
            dependencies: ["SwiftyRequest", .product(name: "OAuth2", package: "google-auth-library-swift")]
        ),
        .testTarget(
            name: "XCBuildLogCollectTests",
            dependencies: ["XCBuildLogCollect"]),
    ]
)
