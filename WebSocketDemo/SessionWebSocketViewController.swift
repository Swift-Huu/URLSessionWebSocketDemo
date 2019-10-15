//
//  SessionWebSocketViewController.swift
//  WebSocketDemo
//
//  Created by 胡智林 on 2019/10/15.
//  Copyright © 2019 胡智林. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SessionWebSocketViewController: BaseWSViewController {
//    weak var session: URLSession?
    let urlStr = "ws://localhost:8090/"
//    let urlStr = "ws://121.40.165.18:8800"
    var wsTask: URLSessionWebSocketTask?
    let sessDelegate = SessionDelegate()
    lazy var session = URLSession.init(configuration: .default, delegate: sessDelegate, delegateQueue: .main)
    override func viewDidLoad() {
        super.viewDidLoad()
//         session = URLSession.init(configuration: .default, delegate: sessDelegate, delegateQueue: .main)
//        wsTask = session.webSocketTask(with: URL.init(string: urlStr)!)
//
//        receiveMsg()
//        wsTask?.resume()
    }
    override func sendButtonTap() {
        if wsTask?.state == .running {
            wsTask?.send(.string(input.text ?? "")) { (error) in
                HUD.show(msg: error.debugDescription)
            }
        } else {
            HUD.show(msg: "WebSocket未打开", detailMsg: "请退出重试")
        }
    }
    func receiveMsg()  {
        wsTask?.receive { (result) in
            switch result {
            case .failure(let error):
                print("receive.failure =  ", error.localizedDescription)
            case .success(let msg):
                switch msg {
                case .data(let data):
                    print("receive.success =  ", String.init(data: data, encoding: .utf8) ?? "")
                case .string(let str):
                    print("receive.success = ", str)
                @unknown default:
                    print("receive.success = ", "unknown")
                }
            }
//            self.receiveMsg()
        }
    }
    deinit {
        print("SessionWebSocketViewController.deinit")
        wsTask?.cancel()
    }

}
@available(iOS 13.0, *)
//extension SessionWebSocketViewController: URLSessionWebSocketDelegate {
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
//        print("didOpenWithProtocol")
//    }
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
//        print("didCloseWith code = ", closeCode)
//    }
//}
class SessionDelegate: NSObject, URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("didOpenWithProtocol")
    }
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("didCloseWith code = ", closeCode)
    }
}
