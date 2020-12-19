//
//  XLTabBar.swift
//  iOS-Demo
//
//  Created by lbs on 2020/11/10.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class XLTabBar: UITabBar {
    
    private(set) lazy var centerBtn: UIButton = UIButton.init()
    private lazy var titeLab = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configSubViews()
        
        // 去掉tabbar上的线条
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance.init()
            appearance.shadowColor = UIColor.clear
            appearance.backgroundColor = .white
            self.standardAppearance = appearance
        } else {
            // Fallback on earlier versions
            UITabBar.appearance().shadowImage = UIImage()
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().backgroundColor = .white
        }
        
        // 添加tabbar上的阴影
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -5)
        self.layer.shadowOpacity = 0.3
        
        
        // 添加中间按钮事件
        centerBtn.addTarget(self, action: #selector(centerBtnAction), for: .touchUpInside)
    }
    
    private func configSubViews() {
        centerBtn.setImage(UIImage(named: "tabbar_center"), for: .normal)
        addSubview(centerBtn)
        
        addSubview(titeLab)
        titeLab.text = "发布"
        titeLab.font = UIFont.systemFont(ofSize: 10)
        titeLab.textColor = .orange
        titeLab.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bringSubviewToFront(centerBtn)
        self.bringSubviewToFront(titeLab)
        
        let btnSize = CGSize(width: 60, height: 60)
        centerBtn.frame = CGRect(x: (self.bounds.width - btnSize.width) / 2.0, y: -20, width: btnSize.width, height: btnSize.height)
        titeLab.frame = CGRect(x: (self.bounds.width - titeLab.intrinsicContentSize.width) * 0.5, y: centerBtn.frame.maxY - 5, width: titeLab.intrinsicContentSize.width, height: titeLab.intrinsicContentSize.height)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func centerBtnAction() {
        print("点击")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == nil {
            let tempPoint = centerBtn.convert(point, from: self)
            if(centerBtn.bounds.contains(tempPoint)) {
                if isHidden == false {
                    return centerBtn
                }
            }
        }
        return view
    }
}

