import Foundation

public class WebsocketBridgeCommand {
  public var onMessage: (([String]) -> Void)? = nil
  public let bridge: WebsocketBridge = WebsocketBridge()
  public init() {}

  func printUsage() {
    print(
      """
      Usage:
          websocket-bridge <appName> <serverPort>
      """)
  }

  public func main() {
    let arguments = CommandLine.arguments
    guard arguments.count == 3 else {
      printUsage()
      return
    }

    let appName = arguments[1]
    let serverPort = arguments[2]
    self.bridge.onMessage = self.onMessage
    self.bridge.connect(appName: appName, serverPort: serverPort)
    RunLoop.main.run()
  }
}
