//
//  MySessionManager.swift
//  AlamofireDemo
//
//  Created by 全宇宙最帅的人 on 2019/10/17.
//  Copyright © 2019 全宇宙最帅的人. All rights reserved.
//

import Foundation
class MySessionManager {
    public let session: URLSession
    public let delegate: MySessionDelegate
    var dataTask: URLSessionDataTask?
    deinit {
        print("MySessionManager.deinit")
        session.invalidateAndCancel()
    }
    public init(
           configuration: URLSessionConfiguration = URLSessionConfiguration.default,
           delegate: MySessionDelegate = MySessionDelegate()){
        self.delegate = delegate
        self.session = URLSession.init(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }
    var completionResponse: ((Data) ->Void)? {
        didSet {
            delegate.completionResponse = completionResponse
        }
    }
    @available(iOS 13.0, *)
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
    @available(iOS 13.0, *)
    public func WSRequest(ws: String) -> URLSessionWebSocketTask {
        let url = URL.init(string: ws)!
        //        let urlReq = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        let wsTask = session.webSocketTask(with: url)
        receiveMsg(wsTask: wsTask)
        wsTask.resume()
        return wsTask
    }
    public func dataRequest(urlStr: String, completion: @escaping (Data) ->Void) {
//        URLSessionDataTask
        completionResponse = completion
        let url = URL.init(string: urlStr)!
//        let urlReq = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        dataTask = session.dataTask(with: url)
        dataTask?.resume()
    }
}
class MyDataRequest {
    
}

class MySessionDelegate: NSObject {
    var completionResponse: ((Data) ->Void)?
    deinit {
        print("MySessionDelegate.deinit")
    }
}
extension MySessionDelegate: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("didReceive response")
        completionHandler(.allow)
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        print("didBecome downloadTask")
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("didReceive data ")
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        print("willCacheResponse ", proposedResponse)
        completionResponse?(proposedResponse.data)
        completionHandler(proposedResponse)
    }
    
}
