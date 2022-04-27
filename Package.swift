// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sections",
    platforms: [
        .iOS(.v13)
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
            name: "Sections",
            exclude: [
                "Info.plist"
            ]
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
