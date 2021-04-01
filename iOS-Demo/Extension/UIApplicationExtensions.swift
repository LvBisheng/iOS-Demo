//
//  UIApplicationExtensions.swift
//  iOS-Demo
//
//  Created by lbs on 2021/4/1.
//  Copyright © 2021 LBS. All rights reserved.
//

import Foundation

extension UIApplication {
    
    /// 获取当前根控制器的top viewcontroller
    static func currentRootTopViewController() -> UIViewController? {
        let appRootCtl = UIApplication.shared.keyWindow?.rootViewController
        if let appRootPresentCtl = appRootCtl?.presentedViewController {
            return appRootPresentCtl
        } else {
            return appRootCtl
        }
    }
    
    /// 获取当前显示在最上面的viewController
    static func currentViewController() -> UIViewController? {
        
        guard let ctl = self.currentRootTopViewController() else {
            return nil
        }
        return self.findTopViewControllerWithCtl(ctl: ctl)
    }
    
    static func findTopViewControllerWithCtl(ctl theCtl: UIViewController) -> UIViewController? {
        if (theCtl is UITabBarController)  {
            let tabbarCtl = theCtl as! UITabBarController
            let ctl = tabbarCtl.selectedViewController
            if(ctl is UINavigationController) {
                return (ctl as! UINavigationController).visibleViewController
            } else {
                return ctl?.presentedViewController ?? ctl
            }
        } else if(theCtl is UINavigationController) {
            return (theCtl as! UINavigationController).visibleViewController
        } else {
            return theCtl.presentedViewController ?? theCtl
        }
    }
}
    
