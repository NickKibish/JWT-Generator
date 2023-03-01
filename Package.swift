// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JWT-Generator",
    products: [
        .executable(
            name: "JWT-Generator",
            targets: ["JWT-Generator"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/Kitura/Swift-JWT", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "JWT-Generator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftJWT", package: "Swift-JWT")
            ]),
        .testTarget(
            name: "JWT-GeneratorTests",
            dependencies: ["JWT-Generator"]),
    ]
)
