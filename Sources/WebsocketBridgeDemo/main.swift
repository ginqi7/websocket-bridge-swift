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
    var port: String? = nil
    port = bridge.getEmacsVar(varName: "websocket-bridge-server-port")
    print(port)
    port = bridge.getEmacsVar(varName: "org-reminders-sync-file")
    print(port)
    port = bridge.getEmacsVar(varName: "org-todo-keywords")
    print(port)

  default:
    print(args)
  }
  print(action)
}
CLI.main()
