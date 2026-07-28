// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sections",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Sections",
            targets: ["Sections"]
        )
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "Sections"
        ),
        .testTarget(
            name: "SectionsTests",
            dependencies: ["Sections"],
            exclude: [
                "Info.plist"
            ]
        )
    ]
)
