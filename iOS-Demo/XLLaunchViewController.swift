//
//  XLLaunchViewController.swift
//  Calling
//
//  Created by lbs on 2020/11/26.
//  Copyright © 2020 XiangLin. All rights reserved.
//

import UIKit

/// 启动页面（这里可以弹出隐私协议授权框、基础配置数据的获取、广告的展示等）
class XLLaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        renderLaunchUI()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(start), userInfo: nil, repeats: false)
    }
    
    private func renderLaunchUI() {
        // 1.拿到LaunchScreen.StoryBoard并生成一个控制器
        let stvc = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        
        // 2.通过控制器的.view生成imgae截图
        let rect = view.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }
        stvc?.view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 3.显示图片
        let imgv = UIImageView.init()
        view.addSubview(imgv)
        imgv.frame = view.bounds
        imgv.image = image
    }
    
    @objc private func start() {
        // do something
    }

    deinit {
        print(#function)
    }
}
