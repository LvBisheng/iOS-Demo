//
//  MacroTool.swift
//  iOS-Demo
//
//  Created by lbs on 2021/3/10.
//  Copyright © 2021 LBS. All rights reserved.
//

import Foundation

// MARK: - 打印相关的配置
enum XLLogType {
    case info
    case sucess
    case error
    case warning
}
func XLLog<T>(_ object: T, _ file : String = #file, funcName : String = #function, lineNum : Int = #line, type: XLLogType = .info) {
    
    #if DEBUG
    var log: String
    switch type {
    case .info:
        log = " 😀 - " + "\(object)"
    case .sucess:
        log = " ✅ - " + "\(object)"
    case .error:
        log = " ❌ - " + "\(object)"
    case .warning:
        log = " ⚠️ - " + "\(object)"
    }
    log = " 😀 - " + "\(object)"
    
    print("\((file as NSString).lastPathComponent)[\(lineNum)],\(funcName):\(log)")
    #endif
}
