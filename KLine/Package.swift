// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KLine",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "KLine",
            targets: ["KLine"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danielgindi/Charts.git", .upToNextMajor(from: "4.0.0"))
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "KLine",
            dependencies: [.product(name: "Charts", package: "Charts")]),
        .testTarget(
            name: "KLineTests",
            dependencies: ["KLine"]),
    ]
)
