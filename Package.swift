// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "WebsocketBridge",
  platforms: [
    .macOS(.v10_15)
  ],
  products: [
    .executable(name: "websocket-bridge-swift-demo", targets: ["WebsocketBridgeDemo"]),
    .library(name: "WebsocketBridgeLibrary", targets: ["WebsocketBridgeLibrary"]),
  ],
  dependencies: [
    .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.6")
  ],
  targets: [
    .target(
      name: "WebsocketBridgeLibrary",
      dependencies: [
        .product(name: "Starscream", package: "Starscream")
      ]),
    .target(
      name: "WebsocketBridgeDemo",
      dependencies: [
        "WebsocketBridgeLibrary"
      ]),
  ]
)
