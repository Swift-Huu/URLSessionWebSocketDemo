//
//  BaseWSViewController.swift
//  WebSocketDemo
//
//  Created by 胡智林 on 2019/10/15.
//  Copyright © 2019 胡智林. All rights reserved.
//

import UIKit
import SnapKit
class BaseWSViewController: UIViewController {
    let input = UITextView()
    lazy var sendButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitle("发送", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(sendButtonTap), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
           view.backgroundColor = .white
        }
        view.addSubview(input)
        view.addSubview(sendButton)
        input.backgroundColor = .lightGray
        
        input.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            } else {
                make.top.equalTo(30)
            }
            make.height.equalTo(100)
        }
        sendButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(input)
            make.top.equalTo(input.snp.bottom).offset(30)
            make.height.equalTo(40)
        }
    }
     @objc public func sendButtonTap() {
    }

}
