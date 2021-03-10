//
//  UITabbarControllerExtension.swift
//  iOS-Demo
//
//  Created by lbs on 2021/3/10.
//  Copyright © 2021 LBS. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController {
    open override var shouldAutorotate: Bool {
            get{
                return selectedViewController!.shouldAutorotate
            }
        }
        
        open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            get {
                return selectedViewController!.supportedInterfaceOrientations
            }
        }
}
