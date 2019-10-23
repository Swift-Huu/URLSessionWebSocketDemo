//
//  WebSocketManage.swift
//  WebSocketDemo
//
//  Created by 全宇宙最帅的人 on 2019/10/18.
//  Copyright © 2019 胡智林. All rights reserved.
//

import Foundation
@available(iOS 13.0, *)
protocol WebSocketManageDelegate: NSObjectProtocol {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?)
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?)
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didReceiveMessage msg: (Result<URLSessionWebSocketTask.Message, Error>))
}
@available(iOS 13.0, *)
class WebSocketManage {
    public weak var delegate: WebSocketManageDelegate?
    public let wsTask: URLSessionWebSocketTask
    public let sessionDelegate: SessionDelegate
    public let session: URLSession
    public let configuration: URLSessionConfiguration
    private let mutex = NSLock()
    public var state: URLSessionTask.State {
        mutex.lock()
        let sta = wsTask.state
        mutex.unlock()
        return sta
    }
    deinit {
        self.cancel(with: .normalClosure, reason: nil)
        session.invalidateAndCancel()
        print("WebSocketManage.deinit")
    }
    init(with url: URL,
         configuration: URLSessionConfiguration = .default,
         sessionDelegate: SessionDelegate = SessionDelegate()) {
        self.sessionDelegate = sessionDelegate
        self.configuration = configuration
        session = URLSession.init(configuration: configuration, delegate: sessionDelegate, delegateQueue: .main)
        wsTask = session.webSocketTask(with: url)
        receiveMsg(wsTask: wsTask)
    }
    public func receiveMsg(wsTask: URLSessionWebSocketTask?){
        wsTask?.receive {[weak self] (result) in
            guard let strongSelf = self else {return}
            strongSelf.receiveMsg?(result)
            strongSelf.delegate?.urlSession(strongSelf.session, webSocketTask: strongSelf.wsTask, didReceiveMessage: result)
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
                    strongSelf.receiveMsg(wsTask: strongSelf.wsTask)
            }
//            strongSelf.receiveMsg(wsTask: wsTask)
        }
    }
    public func resume() {
        wsTask.resume()
    }
    public func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        wsTask.cancel(with: closeCode, reason: reason)
    }
    public func send(_ message: URLSessionWebSocketTask.Message, completionHandler: @escaping (Error?) -> Void) {
        wsTask.send(message, completionHandler: completionHandler)
    }
    private var receiveMsg: ((Result<URLSessionWebSocketTask.Message, Error>) -> Void)?
    public func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
        receiveMsg = completionHandler
    }
    
}
class SessionDelegate: NSObject {
    deinit {
        print("SessionDelegate.deinit")
    }
}
@available(iOS 13.0, *)
extension SessionDelegate: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("didOpenWithProtocol")
    }
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("didCloseWith code = ", closeCode)
    }
}
