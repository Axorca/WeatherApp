// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresenterLayer",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PresenterLayer",
            targets: ["PresenterLayer"]),
    ],
    dependencies: [
        .package(path: "../SharedUtils"),
        .package(path: "../EntityLayer"),
        .package(path: "../InteractorLayer"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.55.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PresenterLayer",
            dependencies: ["SharedUtils",
                           "InteractorLayer",
                           "EntityLayer"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
        .testTarget(
            name: "PresenterLayerTests",
            dependencies: ["PresenterLayer"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
    ]
)
