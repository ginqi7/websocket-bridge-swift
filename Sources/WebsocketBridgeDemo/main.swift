import Darwin
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
    let port = bridge.getEmacsVar(varName: "websocket-bridge-server-port")
  // print(port!)
  default:
    print(args)
  }
  print(action)
}
CLI.main()
