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
        
        let spring = Test_CellModel.init(name: "spring动画") { () -> (Void) in
            let ctrl = TextSpringAnimationCtrl.init()
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        dataSource.append(spring)

        let textViewDemo = Test_CellModel.init(name: "字数限制的textView") { () -> (Void) in
            let ctrl = LimitCountTextViewDemo.init()
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        dataSource.append(textViewDemo)
        
        let fishTabbar = Test_CellModel.init(name: "模仿闲鱼tabbar") { () -> (Void) in
            let ctrl = XLTabbarCtr.init()
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        dataSource.append(fishTabbar)
        
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
        
        let customTags = Test_CellModel.init(name: "自定义的tags") { () -> (Void) in
            let ctrl = CustomTagDemoCtrl.init()
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        dataSource.append(customTags)
        
        let changeNet = Test_CellModel.init(name: "切换网络环境") { () -> (Void) in
            XLNetworkHelper.showChangeNetworkEnvironment()
        }
        dataSource.append(changeNet)
        
        let uikit = Test_CellModel.init(name: "一些自定义的UI组件") { () -> (Void) in
            let ctrl = TestUIKitViewController.init()
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        dataSource.append(uikit)
        
        return dataSource
    }
}
