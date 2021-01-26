// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "RibbonKit",
    platforms: [
        .iOS(.v12), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "RibbonKit",
            targets: ["RibbonKit"]),
    ],
    targets: [
        .target(
            name: "RibbonKit",
            dependencies: [])
    ],
    swiftLanguageVersions: [.v5]
)
