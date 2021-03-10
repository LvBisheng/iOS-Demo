//
//  XLBaseNavigationController.swift
//  iOS-Demo
//
//  Created by lbs on 2021/3/10.
//  Copyright © 2021 LBS. All rights reserved.
//

import UIKit

class XLBaseNavViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
}

/// 设备旋转相关（让子控制器去控制）
extension XLBaseNavViewController {
    open override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return  topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return  topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}

/// 状态栏颜色归子控制器去控制(Info.plist需要配置View controller-based status bar appearance = true)
extension XLBaseNavViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.viewControllers.last?.preferredStatusBarStyle ?? UIStatusBarStyle.default
    }
    
    override var prefersStatusBarHidden: Bool {
        return viewControllers.last?.prefersStatusBarHidden ?? false
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return viewControllers.last?.preferredStatusBarUpdateAnimation ?? .none
    }
}
