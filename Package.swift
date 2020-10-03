// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Lark",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Lark", targets: ["Lark"]),
    ],
    dependencies: [
        .package(url: "https://github.com/screensailor/Peek.git", .branch("trunk")),
        .package(url: "https://github.com/screensailor/Hope.git", .branch("trunk")),
        .package(url: "https://github.com/apple/swift-atomics.git", .upToNextMinor(from: "0.0.1")),
        .package(name: "SE0000_KeyPathReflection", url: "https://github.com/apple/swift-evolution-staging.git", .branch("reflection"))
    ],
    targets: [
        .target(
            name: "Lark",
            dependencies: [
                .byName(name: "Peek"),
                .product(name: "Atomics", package: "swift-atomics"),
                .product(name: "SE0000_KeyPathReflection", package: "SE0000_KeyPathReflection")
            ]
        ),
        .testTarget(name: "LarkTests", dependencies: ["Lark", "Peek", "Hope"]),
    ]
)
