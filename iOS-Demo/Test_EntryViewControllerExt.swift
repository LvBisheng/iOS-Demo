//
//  Test_EntryViewControllerExt.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/17.
//  Copyright © 2020 LBS. All rights reserved.
//

import Foundation

extension Test_EntryViewController {
    func other() -> [Test_CellModel] {
        var dataSource:[Test_CellModel] = []

        let html = Test_CellModel.init(name: "加载网络资源") { () -> (Void) in
            let ctrl = BaseWebViewController.init()
            ctrl.type = .loadURL(str: "https://www.baidu.com")
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        dataSource.append(html)
        
        
        return dataSource
    }
}
