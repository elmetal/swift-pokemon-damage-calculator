// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-pokemon-damage-calculator",
    platforms: [.macOS(.v26)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "swift-pokemon-damage-calculator",
            targets: ["swift-pokemon-damage-calculator"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/elmetal/swift-pokemon-types", from: "0.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "swift-pokemon-damage-calculator",
            dependencies: [
                .product(name: "PokemonTypes", package: "swift-pokemon-types")
            ]
        ),
        .testTarget(
            name: "swift-pokemon-damage-calculatorTests",
            dependencies: [
                "swift-pokemon-damage-calculator",
                .product(name: "PokemonTypes", package: "swift-pokemon-types"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
