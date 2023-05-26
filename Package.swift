// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "vapor",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "Vapor", targets: ["Vapor"]),
        .library(name: "XCTVapor", targets: ["XCTVapor"]),
    ],
    dependencies: [
        // HTTP client library built on SwiftNIO
        .package(url: "https://github.com/swift-server/async-http-client.git", exact: "1.18.0"),

        // Sugary extensions for the SwiftNIO library
        .package(url: "https://github.com/vapor/async-kit.git", exact: "1.17.0"),

        // 💻 APIs for creating interactive CLI tools.
        .package(url: "https://github.com/vapor/console-kit.git", exact: "4.6.0"),

        // 🔑 Hashing (SHA2, HMAC), encryption (AES), public-key (RSA), and random data generation.
        .package(url: "https://github.com/apple/swift-crypto.git", exact: "2.5.0"),

        // 🚍 High-performance trie-node router.
        .package(url: "https://github.com/vapor/routing-kit.git", exact: "4.7.2"),

        // 💥 Backtraces for Swift on Linux
        .package(url: "https://github.com/swift-server/swift-backtrace.git", exact: "1.3.3"),
        
        // Event-driven network application framework for high performance protocol servers & clients, non-blocking.
        .package(url: "https://github.com/apple/swift-nio.git", exact: "2.53.0"),
        
        // Bindings to OpenSSL-compatible libraries for TLS support in SwiftNIO
        .package(url: "https://github.com/apple/swift-nio-ssl.git", exact: "2.24.0"),
        
        // HTTP/2 support for SwiftNIO
        .package(url: "https://github.com/apple/swift-nio-http2.git", exact: "1.26.0"),
        
        // Useful code around SwiftNIO.
        .package(url: "https://github.com/apple/swift-nio-extras.git", exact: "1.19.0"),
        
        // Swift logging API
        .package(url: "https://github.com/apple/swift-log.git", exact: "1.5.2"),

        // Swift metrics API
        .package(url: "https://github.com/apple/swift-metrics.git", exact: "2.3.4"),
        
        // Swift collection algorithms
        .package(url: "https://github.com/apple/swift-algorithms.git", exact: "1.0.0"),

        // WebSocket client library built on SwiftNIO
        .package(url: "https://github.com/vapor/websocket-kit.git", exact: "2.9.1"),
        
        // MultipartKit, Multipart encoding and decoding
        .package(url: "https://github.com/vapor/multipart-kit.git", exact: "4.5.4"),
    ],
    targets: [
        // C helpers
        .target(name: "CVaporBcrypt"),
        .target(name: "CVaporURLParser"),

        // Vapor
        .target(name: "Vapor", dependencies: [
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
            .product(name: "AsyncKit", package: "async-kit"),
            .product(name: "Backtrace", package: "swift-backtrace"),
            .target(name: "CVaporBcrypt"),
            .target(name: "CVaporURLParser"),
            .product(name: "ConsoleKit", package: "console-kit"),
            .product(name: "Logging", package: "swift-log"),
            .product(name: "Metrics", package: "swift-metrics"),
            .product(name: "NIO", package: "swift-nio"),
            .product(name: "NIOConcurrencyHelpers", package: "swift-nio"),
            .product(name: "NIOCore", package: "swift-nio"),
            .product(name: "NIOExtras", package: "swift-nio-extras"),
            .product(name: "NIOFoundationCompat", package: "swift-nio"),
            .product(name: "NIOHTTPCompression", package: "swift-nio-extras"),
            .product(name: "NIOHTTP1", package: "swift-nio"),
            .product(name: "NIOHTTP2", package: "swift-nio-http2"),
            .product(name: "NIOSSL", package: "swift-nio-ssl"),
            .product(name: "NIOWebSocket", package: "swift-nio"),
            .product(name: "Crypto", package: "swift-crypto"),
            .product(name: "Algorithms", package: "swift-algorithms"),
            .product(name: "RoutingKit", package: "routing-kit"),
            .product(name: "WebSocketKit", package: "websocket-kit"),
            .product(name: "MultipartKit", package: "multipart-kit"),
        ]),
	
        // Development
        .executableTarget(
            name: "Development",
            dependencies: [
                .target(name: "Vapor"),
            ],
            resources: [.copy("Resources")],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags([
                    "-cross-module-optimization"
                ], .when(configuration: .release)),
            ]
        ),

        // Testing
        .target(name: "XCTVapor", dependencies: [
            .target(name: "Vapor"),
        ]),
        .testTarget(name: "VaporTests", dependencies: [
            .product(name: "NIOTestUtils", package: "swift-nio"),
            .target(name: "XCTVapor"),
        ], resources: [
            .copy("Utilities/foo.txt"),
            .copy("Utilities/index.html"),
            .copy("Utilities/SubUtilities/"),
            .copy("Utilities/foo bar.html"),
            .copy("Utilities/test.env"),
            .copy("Utilities/my-secret-env-content"),
            .copy("Utilities/expired.crt"),
            .copy("Utilities/expired.key"),
        ]),
        .testTarget(name: "AsyncTests", dependencies: [
            .product(name: "NIOTestUtils", package: "swift-nio"),
            .target(name: "XCTVapor"),
        ]),
    ]
)
