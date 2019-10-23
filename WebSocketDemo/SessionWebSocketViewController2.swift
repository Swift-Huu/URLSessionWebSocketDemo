//
//  SessionWebSocketViewController2.swift
//  WebSocketDemo
//
//  Created by 全宇宙最帅的人 on 2019/10/18.
//  Copyright © 2019 胡智林. All rights reserved.
//

import UIKit
@available(iOS 13.0, *)
class SessionWebSocketViewController2: BaseWSViewController {
//    let urlStr = "ws://localhost:8090/"
        let urlStr = "ws://121.40.165.18:8800"
    var wsManage: WebSocketManage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wsManage = WebSocketManage.init(with: URL.init(string: urlStr)!)
        wsManage?.resume()
        // Do any additional setup after loading the view.
    }
    override func sendButtonTap() {
        if wsManage?.state == .running {
            wsManage?.send(.string(input.text ?? "")) { (error) in
                if let error = error {
                    HUD.show(msg: error.localizedDescription)
                }
            }
        } else {
            HUD.show(msg: "WebSocket未打开", detailMsg: "请退出重试")
        }
    }
    deinit {
        wsManage?.cancel(with: .normalClosure, reason: nil)
        wsManage?.session.invalidateAndCancel()
        print("SessionWebSocketViewController2.deinit")
        
    }
    
    
    
}
