// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "RibbonKit",
    platforms: [
        .iOS(.v13), .tvOS(.v13)
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
