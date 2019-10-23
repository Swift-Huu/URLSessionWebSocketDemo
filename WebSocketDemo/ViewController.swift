//
//  ViewController.swift
//  WebSocketDemo
//
//  Created by 胡智林 on 2019/10/14.
//  Copyright © 2019 胡智林. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let searchBar = UISearchBar.init(frame: .init(x: 0, y: 0, width: 200, height: 20))
        navigationItem.titleView = searchBar
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = SocketRocketViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = StarscreamViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            if #available(iOS 13.0, *) {
                let vc = SessionWebSocketViewController()
                navigationController?.pushViewController(vc, animated: true)
            } else {
            }
            case 3:
                if #available(iOS 13.0, *) {
                    let vc = SessionWebSocketViewController2()
                    navigationController?.pushViewController(vc, animated: true)
            }
            
            default:
                print("default")
        }
    }
}

