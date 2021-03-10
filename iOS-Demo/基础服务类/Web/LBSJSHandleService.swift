//
//  LBSJSHandleService.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/17.
//  Copyright © 2020 LBS. All rights reserved.
//

import Foundation
import WebKit

/// JS调用Native messageName
let kLBSJSToNativeMsgName = "jsToNativeMsgMethod"

struct LBSJSHandleService {
    static let shared = LBSJSHandleService.init()
    func handleJSMessage(_ message: WKScriptMessage, currentController: UIViewController) {
        if message.name == kLBSJSToNativeMsgName {
            UIApplication.currentViewController()?.alert(message: "js调用原生")
            return
        }
    }
}
