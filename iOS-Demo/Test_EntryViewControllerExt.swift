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

        
        let toupiaojieguo = Test_CellModel.init(name: "投票结果展示") { () -> (Void) in
            let ctrl = ToupiaoJIeGuoCtrl.init()
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        dataSource.append(toupiaojieguo)

        
        let html = Test_CellModel.init(name: "加载网络资源") { () -> (Void) in
            let ctrl = BaseWebViewController.init()
            ctrl.type = .loadURL(str: "https://www.baidu.com")
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        dataSource.append(html)
        
        let h5Bridge = Test_CellModel.init(name: "和H5交互") { () -> (Void) in
            let ctrl = BaseWebViewController.init()
            ctrl.type = .loadHtml(fileName: "H5Bridge")
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        dataSource.append(h5Bridge)
        
        let tagsView = Test_CellModel.init(name: "在tableViewCell中使用tagsView") { () -> (Void) in
            let ctrl = TableTagsDemoCtrl.init()
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        dataSource.append(tagsView)
        
        let nomalTags = Test_CellModel.init(name: "普通的tags") { () -> (Void) in
            let ctrl = NomalTagsDemoCtrl.init()
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        dataSource.append(nomalTags)
        
        
        return dataSource
    }
}
