// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "current_locale",
    platforms: [
        .iOS("13.0"),
        // .macOS("10.14")
    ],
    products: [
        // If the plugin name contains "_", replace with "-" for the library name.
        .library(name: "current-locale", targets: ["current_locale"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "current_locale",
            dependencies: [],
            resources: [
            ]
        ),
    ]
)
