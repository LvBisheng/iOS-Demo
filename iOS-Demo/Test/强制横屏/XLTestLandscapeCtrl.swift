//
//  XLTestLandscapeCtrl.swift
//  iOS-Demo
//
//  Created by lbs on 2021/3/10.
//  Copyright © 2021 LBS. All rights reserved.
//

import UIKit

class XLTestLandscapeCtrl: XLBaseViewController {
    
    // 屏幕旋转设置
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    
    // 状态栏设置(iOS 13以上状态栏显示不出来，可以考虑自定义状态栏)
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let lab = UILabel.init()
        lab.text = "哈哈哈";
        view.addSubview(lab)
        lab.snp_makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(50)
        }
        
        let closeBtn = UIButton.init()
        view.addSubview(closeBtn)
        closeBtn.setTitle("关闭", for: .normal)
        closeBtn.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
        }
        closeBtn.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func closePage() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
