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
//    let urlStr = "ws://localhost:8090/"
    let urlStr = "ws://121.40.165.18:8800"
    var wsTask: URLSessionWebSocketTask?
//   weak var sessDelegate = SessionDelegate()
    public let delegate: MySessionDelegate
//    lazy var session = URLSession.init(configuration: .default, delegate: delegate, delegateQueue: .main)
    var session: URLSession = URLSession.shared
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        wsTask = session.webSocketTask(with: URL.init(string: urlStr)!)
        receiveMsg(wsTask: wsTask)
        wsTask?.resume()
    }
    override func sendButtonTap() {
        if wsTask?.state == .running {
            wsTask?.send(.string(input.text ?? "")) { (error) in
                if let error = error {
                    HUD.show(msg: error.localizedDescription)
                }
            }
        } else {
            HUD.show(msg: "WebSocket未打开", detailMsg: "请退出重试")
        }
    }
    func receiveMsg(wsTask: URLSessionWebSocketTask?){
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
                    self.receiveMsg(wsTask: wsTask)
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        wsTask?.cancel()
//        session?.invalidateAndCancel()
//        wsTask?.cancel(with: .normalClosure, reason: nil)
//        wsTask?.cancel()
//        wsTask = nil
//        session = nil
    }
    deinit {
        print("SessionWebSocketViewController.deinit")

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
class SessionDelegate: NSObject {
    
}
//extension SessionDelegate: URLSessionWebSocketDelegate {
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
//        print("didOpenWithProtocol")
//    }
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
//        print("didCloseWith code = ", closeCode)
//    }
//}
//extension SessionDelegate: {
//
//}
