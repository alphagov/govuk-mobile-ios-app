// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GOVKit",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GOVKit",
            targets: ["GOVKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/alphagov/govuk-mobile-ios-ui-components", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "GOVKit",
            dependencies: [
                .product(name: "UIComponents", package: "govuk-mobile-ios-ui-components")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "GOVKitTests",
            dependencies: ["GOVKit"]
        ),
    ]
)
