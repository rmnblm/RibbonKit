// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "RibbonKit",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "RibbonKit",
            targets: ["RibbonKit"]
        ),
    ],
    targets: [
        .target(
            name: "RibbonKit",
            dependencies: []
        )
    ]
)
