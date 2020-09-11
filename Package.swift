// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Lark",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "Lark", targets: ["Lark"]),
        .library(name: "Peek", targets: ["Peek"]),
        .library(name: "Hope", targets: ["Hope"]),
    ],
    targets: [
        .target(name: "Lark", dependencies: ["Peek"]),
        .target(name: "Peek"),
        .target(name: "Hope"),
        .testTarget(name: "LarkTests", dependencies: ["Lark", "Peek", "Hope"]),
        .testTarget(name: "PeekTests", dependencies: ["Peek", "Hope"]),
    ]
)
