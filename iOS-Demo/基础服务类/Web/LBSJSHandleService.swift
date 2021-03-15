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
let kLBSNativeToJsMsgName = "nativeToJsMsgMethod"

struct LBSJSHandleService {
    static let shared = LBSJSHandleService.init()
    func handleJSMessage(_ message: WKScriptMessage, currentController: UIViewController) {
        if message.name == kLBSJSToNativeMsgName {
            print("原生监听到JS的调用, name: \(message.name), body参数: \(message.body)")
            return
        }
    }
}
