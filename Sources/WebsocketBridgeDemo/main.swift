import Darwin
import Foundation
import WebsocketBridgeLibrary

let CLI = WebsocketBridgeCommand()
let bridge = CLI.bridge
CLI.onMessage = { args in
  let action = args[0]
  switch action {
  case "message":
    bridge.messageToEmacs(message: args[1])
  case "value":
    print(args)
    print(bridge.getEmacsVar(varName: "websocket-bridge-server-port") ?? "Not found")
    print(bridge.getEmacsVar(varName: "org-reminders-sync-file") ?? "Not found")
    print(bridge.getEmacsVar(varName: "org-reminders-sync-frequency", example: 0) ?? 0)

  case "runInEmacs":
    bridge.runInEmacs(function: "message", "hello", "World", "999")
  default:
    print(args)
  }
  print(action)
}
CLI.main()
