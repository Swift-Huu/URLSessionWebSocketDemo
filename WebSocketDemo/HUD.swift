//
//  HUD.swift
//  WebSocketDemo
//
//  Created by 胡智林 on 2019/10/15.
//  Copyright © 2019 胡智林. All rights reserved.
//

import MBProgressHUD
class HUD: NSObject {
    @objc public static func show(msg: String?, detailMsg: String? = nil) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        hud.mode = .text
        hud.label.text = msg
        hud.detailsLabel.text = detailMsg
        hud.hide(animated: true, afterDelay: 1.5)
    }
}
