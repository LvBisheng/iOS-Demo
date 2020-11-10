//
//  XLTabbarCtr.swift
//  iOS-Demo
//
//  Created by lbs on 2020/11/10.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class XLTabbarCtr: UITabBarController {
    
    private lazy var myTabbar: XLTabBar = {
        let myTabbar = XLTabBar.init()
        myTabbar.centerBtn.addTarget(self, action: #selector(centerBtnClickAction), for: .touchUpInside)
        return myTabbar
    }()
    
    private lazy var placeHolderCtrl: UIViewController = {
        let placeHolderCtrl = UIViewController.init()
        placeHolderCtrl.view.backgroundColor = .red
        return placeHolderCtrl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        myTabbar.isTranslucent = false
        self.setValue(myTabbar, forKeyPath: "tabBar")
        addChildViewControllers()
        
        self.delegate = self
    }
    

    func addChildViewControllers() {
        let fish = UIViewController.init()
        fish.view.backgroundColor = .white
        fish.tabBarItem.title = "闲鱼"
        fish.tabBarItem.selectedImage = UIImage(named: "tabbar_community_h")
        fish.tabBarItem.image = UIImage(named: "tabbar_community_n")

        let pond = UIViewController.init()
        pond.tabBarItem.title = "鱼塘"
        pond.view.backgroundColor = .orange
        pond.tabBarItem.selectedImage = UIImage(named: "tabbar_community_h")
        pond.tabBarItem.image = UIImage(named: "tabbar_community_n")

       

        let msg = UIViewController.init()
        msg.tabBarItem.title = "消息"
        msg.view.backgroundColor = .yellow
        msg.tabBarItem.selectedImage = UIImage(named: "tabbar_community_h")
        msg.tabBarItem.image = UIImage(named: "tabbar_community_n")

        
        let mine = UIViewController.init()
        mine.tabBarItem.title = "我的"
        mine.view.backgroundColor = .systemPink
        mine.tabBarItem.selectedImage = UIImage(named: "tabbar_community_h")
        mine.tabBarItem.image = UIImage(named: "tabbar_community_n")

        let itemArr = [fish, pond, placeHolderCtrl, msg, mine]
        viewControllers = itemArr
    }
    
    @objc func centerBtnClickAction() {
        self.alert(message: "点击了")
    }

}

extension XLTabbarCtr: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == placeHolderCtrl {
            return false
        }
        return true
    }
}
