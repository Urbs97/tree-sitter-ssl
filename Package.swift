// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "TreeSitterSsl",
    products: [
        .library(name: "TreeSitterSsl", targets: ["TreeSitterSsl"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ChimeHQ/SwiftTreeSitter", from: "0.8.0"),
    ],
    targets: [
        .target(
            name: "TreeSitterSsl",
            dependencies: [],
            path: ".",
            sources: [
                "src/parser.c",
                // NOTE: if your language has an external scanner, add it here.
            ],
            resources: [
                .copy("queries")
            ],
            publicHeadersPath: "bindings/swift",
            cSettings: [.headerSearchPath("src")]
        ),
        .testTarget(
            name: "TreeSitterSslTests",
            dependencies: [
                "SwiftTreeSitter",
                "TreeSitterSsl",
            ],
            path: "bindings/swift/TreeSitterSslTests"
        )
    ],
    cLanguageStandard: .c11
)
