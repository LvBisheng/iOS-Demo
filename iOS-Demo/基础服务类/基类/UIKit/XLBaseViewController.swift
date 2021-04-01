//
//  XLBaseViewController.swift
//  iOS-Demo
//
//  Created by lbs on 2021/3/10.
//  Copyright © 2021 LBS. All rights reserved.
//

import Foundation
import UIKit

class XLBaseViewController: UIViewController {
    var isPresent: Bool = false
    
    public typealias Complete = ((XLBaseViewController?, Any?) -> Void)
    public typealias CloseClicked = ((XLBaseViewController) -> ())
    
    /// 完成的回调。(比如A push B， B发布了内容，A需要监听并刷新，就可以回调这个block)
    open var complete: Complete?
    /// 关闭界面的回调
    open var closeClicked: CloseClicked?
    
    
    private let backButtonTitleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
    lazy private var backButton: UIButton = {
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(UIImage.init(named: "nav_back"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        return backButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // 不想要四个边缘均延伸
        self.edgesForExtendedLayout = []
        
        self.view.backgroundColor = UIColor.lightGray
        
        setupNav()
        
    }
    
   
  
    
    /// 关闭控制器。如果是push过来的，就进行pop,否者调用的是navigationController的dismiss方法
    /// - Parameters:
    ///   - animated: 是否需要动画
    ///   - completion: 关闭后的回调
    func close(animated: Bool = true, _ completion: (() -> Void)? = nil) {
        if navigationController?.viewControllers.count ?? 0 > 1 {
            self.navigationController?.popViewController(animated: animated)
        } else {
            if isPresent {
                navigationController?.dismiss(animated: true, completion: completion)
            } else {
                self.navigationController?.dismiss(animated: animated, completion: completion)
            }
        }
    }
    
    @objc private func back() {
        self.close()
    }
    
    /// 保存信息成功，并回调complete。比如A push B, B提交信息调用此方法，A就可以拿到complete的回调
    func xl_saveInfoCompletion() {
        self.complete?(self, nil)
        self.back()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        XLLog("\(self)销毁了")
    }
    
}

// MARK: - 导航栏相关
extension XLBaseViewController {
    // 设置导航栏
    private func setupNav() {
        if self.navigationController?.viewControllers.count ?? 0 > 1 || isPresent == true {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
        }
    
        navigationController?.navigationBar.barTintColor = UIColor.orange
        
        
    }

}
