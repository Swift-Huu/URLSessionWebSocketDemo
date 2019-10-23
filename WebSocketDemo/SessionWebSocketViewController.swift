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
    let urlStr = "ws://localhost:8090/"
    //    let urlStr = "ws://121.40.165.18:8800"
    var wsTask: URLSessionWebSocketTask?
    var delegate: SessionDelegate?
    var session: URLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = SessionDelegate()
        session =  URLSession.init(configuration: .default, delegate: delegate!, delegateQueue: .main)
        wsTask = session?.webSocketTask(with: URL.init(string: urlStr)!, protocols: ["hu123"])
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
        wsTask?.receive { [weak self](result) in
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
                    self?.receiveMsg(wsTask: wsTask)
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    deinit {
        wsTask?.cancel(with: .normalClosure, reason: nil)
        session?.invalidateAndCancel()
        print("SessionWebSocketViewController.deinit")
        
    }
    
}


