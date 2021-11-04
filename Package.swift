// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "RibbonKit",
    platforms: [
        .iOS(.v14), .tvOS(.v14)
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
