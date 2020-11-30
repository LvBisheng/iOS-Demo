//
//  XLNetworkHelper.swift
//  iOS-Demo
//
//  Created by lbs on 2020/11/30.
//  Copyright © 2020 LBS. All rights reserved.
//

import Foundation
import UIKit

class XLConfigs: NSObject {
    ///  是否开启网络host切换功能，这相当于总开关打。AppStore包的时候一定要设为false，平常调试或者发普通测试包可设置为true
    static let isEnableChangeBaseUrl = true;
}

// 测试环境
private let kXLINetEnvi_main_test = "https://test-calling-api.apyfc.com"
private let kXLINetEnvi_H5_test = kXLINetEnvi_main_test


// 生产环境
private let kXLINetEnvi_main_release = "https://test-calling-api.apyfc.com"
private let kXLINetEnvi_H5_release = "https://calling-slb.apyfc.com"

// 灰度环境
private let kXLINetEnvi_main_gray = "https://calling-slb.apyfc.com"
private let kXLINetEnvi_H5_gray = kXLINetEnvi_H5_release


// 默认网络的环境
private let kDefaultNetEnvironment = XLNetEnvironment.release


private let kXLNetworkEnvironmentKey = "kXLNetworkEnvironment"

enum XLNetEnvironment: Int, Codable {
    case test = 1
    case release = 2
    case gray = 3
    
    func desc() -> String {
        switch self {
        case .test:
            return "测试环境"
        case .release:
            return "生产环境"
        case .gray:
            return "灰度环境"
        }
    }
}

@objcMembers class XLNetworkEnviromentInfo : NSObject {
    /// 主要模块的域名
    var main: String = kXLINetEnvi_main_release
    /// H5页面
    var H5Host: String = kXLINetEnvi_H5_release
}

/// 这个类主要是处理网络相关的东西，例如网络环境切换，全局的header参数
class XLNetworkHelper : NSObject {
    
    // MARK: - private
    private static let testEnviInfo: XLNetworkEnviromentInfo = {
        var test = XLNetworkEnviromentInfo.init()
        test.main = kXLINetEnvi_main_test
        test.H5Host = kXLINetEnvi_H5_test
        return test
    }()
    
    private static let releaseEnviInfo: XLNetworkEnviromentInfo = {
        var release = XLNetworkEnviromentInfo.init()
        release.main = kXLINetEnvi_main_release
        release.H5Host = kXLINetEnvi_H5_release
        return release
    }()
    
    private static let grayEnviInfo: XLNetworkEnviromentInfo = {
        var gray = XLNetworkEnviromentInfo.init()
        gray.main = kXLINetEnvi_main_gray
        gray.H5Host = kXLINetEnvi_H5_gray
        return gray
   }()
    
    // MARK: - public
    static func networkHeaders() -> [String: String] {
        
        // TODO: 这边还差一个手机型号
        let tempHeaders:[String : String] =
            [
                "Content-type": "application/json",
             "X-Requested-With": "XMLHttpRequest",
             "clientType": "sIOS",
             "ostype": "iOS",
             "version": (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ) ?? "",
            ]
        return tempHeaders
    }
    
    /// 当前环境的信息
    @objc static func currentEnviInfo() -> XLNetworkEnviromentInfo {
        // 判断是不是 APPStore包
        if !(XLConfigs.isEnableChangeBaseUrl) {
            return releaseEnviInfo
        }
        
        switch XLNetworkHelper.currentNetworkEnvironment() {
        case .test:
            return testEnviInfo
        case .release:
            return releaseEnviInfo
        case .gray:
            return grayEnviInfo
        }
    }
    
}

// MARK: - ============切换网络环境相关=========
extension XLNetworkHelper {
    /// 返回当前的网络环境
    static func currentNetworkEnvironment() -> XLNetEnvironment {
        // 判断是不是 APPStore包
        if !(XLConfigs.isEnableChangeBaseUrl) { return XLNetEnvironment.release }
        if let rawValue = UserDefaults.standard.object(forKey: kXLNetworkEnvironmentKey) as? Int {
            return XLNetEnvironment(rawValue: rawValue) ?? kDefaultNetEnvironment
        } else {
            return kDefaultNetEnvironment
        }
    }
    
    /// 设置当前网络环境
    static func setNetworkEnvironment(_ envi: XLNetEnvironment) {
        // 判断是不是 APPStore包
        if !(XLConfigs.isEnableChangeBaseUrl) { return }
        UserDefaults.standard.set(envi.rawValue, forKey: kXLNetworkEnvironmentKey)
        UserDefaults.standard.synchronize()
    }
    
    /// 弹框切换环境
    static func showChangeNetworkEnvironment(compelte: (()->())? = nil) {
        let ctrl = UIAlertController.init(title: "切换网络环境", message: "当前网络环境为\(XLNetworkHelper.currentNetworkEnvironment().desc())" + XLNetworkHelper.currentEnviInfo().main, preferredStyle: .actionSheet)
        // 测试
        let alert0 = UIAlertAction.init(title: XLNetEnvironment.test.desc(), style: .default) { (action) in
            XLNetworkHelper.setNetworkEnvironment(.test)
            compelte?()
        }
        ctrl.addAction(alert0)
        
        // 生产
        let alert2 = UIAlertAction.init(title: XLNetEnvironment.release.desc(), style: .default) { (action) in
            XLNetworkHelper.setNetworkEnvironment(.release)
            compelte?()
        }
        ctrl.addAction(alert2)
        
        // 灰度
        let alert3 = UIAlertAction.init(title: XLNetEnvironment.gray.desc(), style: .default) { (action) in
            XLNetworkHelper.setNetworkEnvironment(.gray)
            compelte?()
        }
        ctrl.addAction(alert3)
        
        let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
        }
        ctrl.addAction(cancel)
        
        UIApplication.currentViewController()?.present(ctrl, animated: true, completion: nil)
    }
}

