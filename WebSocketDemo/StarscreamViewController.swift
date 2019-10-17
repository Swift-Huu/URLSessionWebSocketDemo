//
//  StarscreamViewController.swift
//  WebSocketDemo
//
//  Created by 胡智林 on 2019/10/15.
//  Copyright © 2019 胡智林. All rights reserved.
//

import UIKit
import Starscream

class StarscreamViewController: BaseWSViewController {
    var socket: WebSocket?
    let mySessionManager = MySessionManager.init()
    override func viewDidLoad() {
        super.viewDidLoad()
//        let wsStr = "ws://localhost:8090/"
        let wsStr = "ws://121.40.165.18:8800"
//        socket = .init(url: URL.init(string: wsStr)!)
//        socket?.delegate = self
//        socket?.connect()
        if #available(iOS 13.0, *) {
            mySessionManager.WSRequest(ws: wsStr)
        } else {
            // Fallback on earlier versions
        }
    }
    deinit {
        print("StarscreamViewController.deinit")
        socket?.disconnect()
        socket?.delegate = nil
        socket = nil
    }
    override func sendButtonTap() {
        if socket?.isConnected ?? false {
            socket?.write(string: input.text ?? "")
        } else {
            HUD.show(msg: "WebSocket未打开", detailMsg: "请退出重试")
        }
        
    }
}
extension StarscreamViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocketDidConnect")
    }
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect")
    }
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("websocketDidReceiveMessage = ", text)
    }
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData = ", String.init(data: data, encoding: .utf8) ?? "")
    }
}
