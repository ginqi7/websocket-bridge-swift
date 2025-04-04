import Foundation
import Starscream

public class WebsocketBridge {
  // MARK: - Properties
  private var appName: String? = nil
  private var serverPort: String? = nil
  private var client: WebSocket? = nil
  private let jsonEncoder = JSONEncoder()
  private let jsonDecoder = JSONDecoder()
  public var onMessage: (([String]) -> Void)? = nil

  public init() {
  }

  // MARK: - Public Methods
  public func connect(appName: String, serverPort: String) {
    self.appName = appName
    self.serverPort = serverPort
    let url = URL(string: "http://127.0.0.1:\(serverPort)")!
    var request = URLRequest(url: url)
    request.timeoutInterval = 5
    self.client = WebSocket(request: request)
    self.client!.callbackQueue = DispatchQueue(label: "com.qiqijin.websocket-bridge.main")
    self.client!.onEvent = didReceive(event:)
    self.client!.connect()
  }

  public func send(str: String) {
    self.client!.write(string: str)
  }

  public func messageToEmacs(message: String) {
    var dict: [String: String] = [:]
    dict["type"] = "show-message"
    dict["content"] = message
    send(str: toJson(dict: dict))
  }

  public func evalInEmacs(code: String) {
    var dict: [String: String] = [:]
    dict["type"] = "eval-code"
    dict["content"] = code
    print(code)
    send(str: toJson(dict: dict))
  }

  public func runInEmacs(function: String, _ args: String...) {
    let argsString = args.map { "\"\($0)\"" }.joined(separator: " ")
    let code = "(\(function) \(argsString))"
    evalInEmacs(code: code)
  }

  public func getEmacsVar(varName: String) -> String? {
    var value: String? = nil
    if let json = getEmacsVarJson(varName: varName) {
      do {
        if let data = json.data(using: String.Encoding.utf8) {
          value = try JSONDecoder().decode(String.self, from: data)
        }
      } catch let error {
        print("Error: \(error)")
      }
    }
    print("Variable [\(varName)] is \(value ?? "nil") in Emacs.")
    return value
  }

  public func getEmacsVar(varName: String, example: Int) -> Int? {
    var value: Int? = nil
    if let json = getEmacsVarJson(varName: varName) {
      do {
        if let data = json.data(using: String.Encoding.utf8) {
          value = try JSONDecoder().decode(Int.self, from: data)
        }
      } catch let error {
        print("Error: \(error)")
      }
    }
    let valueStr = String(describing: value)
    print("Variable [\(varName)] is \(valueStr) in Emacs.")
    return value
  }

  public func getEmacsVarJson(varName: String) -> String? {
    let dict: [String: String] = [
      "type": "fetch-var",
      "content": varName,
    ]
    var value: String? = nil
    let tempClient = createTemporaryWebSocket()
    let semaphore = DispatchSemaphore(value: 0)
    tempClient.onEvent = { event in
      switch event {
      case .connected(_):
        tempClient.write(string: self.toJson(dict: dict))
        break
      case .text(let string):
        value = string
        tempClient.disconnect()
        semaphore.signal()
        break
      default:
        break
      }
    }
    tempClient.connect()
    semaphore.wait()
    return value
  }
  // MARK: - Private Methods

  private func didReceive(event: WebSocketEvent) {
    switch event {
    case .connected(_):
      print("WebSocket Client \(appName!) connected, the server port is \(serverPort!)")
      let dict: [String: String] = [
        "type": "client-app-name",
        "content": self.appName!,
      ]
      self.client!.write(string: toJson(dict: dict))
    case .disconnected(let reason, let code):
      print("WebSocket is disconnected: \(reason) with code: \(code)")
    case .text(let string):
      let array = jsonToArray(str: string)
      if let data = array[1] as? [String] {
        if let onMessage = self.onMessage {
          onMessage(data)
        } else {
          print("You should implement 'onMessage' yourself.")
        }
      }

    default:
      break
    }
  }

  private func toJson(dict: [String: String]) -> String {
    let encoder = JSONEncoder()
    let encoded = try! encoder.encode(dict)
    return String(data: encoded, encoding: .utf8) ?? ""
  }

  private func createTemporaryWebSocket() -> WebSocket {
    let url = URL(string: "http://127.0.0.1:\(serverPort!)")!
    var request = URLRequest(url: url)
    request.timeoutInterval = 5
    let socket: WebSocket = WebSocket(request: request)
    socket.callbackQueue = DispatchQueue(label: "com.qiqijin.websocket-bridge.temp")
    return socket
  }

  private func jsonToArray(str: String) -> [Any] {
    if let jsonData = str.data(using: .utf8) {
      do {
        if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: [])
          as? [Any]
        {
          return dictionary
        }
      } catch {
        return []
      }
    }
    return []
  }
}
