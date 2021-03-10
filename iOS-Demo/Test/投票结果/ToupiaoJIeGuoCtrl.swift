//
//  ToupiaoJIeGuoCtrl.swift
//  iOS-Demo
//
//  Created by lbs on 2020/11/9.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit
class ToupiaoJIeGuoCtrl: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        test()
        
    }

    func test() {
        let theView = TestView()
        view.addSubview(theView)
        theView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 300)
        theView.backgroundColor = UIColor.cyan
    }

}

class TestView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        let leftRatio: CGFloat = 0.5
        
        
        let radius: CGFloat = 25
        let top: CGFloat = 100
        let pading: CGFloat = 10
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(UIColor.orange.cgColor)
        
//        let l_right_top = CGPoint(x: leftRatio * rect.width + 20, y: top)
        let l_right_top = CGPoint(x: leftRatio * rect.width, y: top)

        let l_right_bottom = CGPoint(x: leftRatio * rect.width, y: radius * 2.0 + top)
        
        let r_left_bottom = CGPoint(x: l_right_bottom.x + pading, y: l_right_bottom.y)
        let r_left_top = CGPoint(x: l_right_top.x + pading, y: l_right_top.y)
        
        
        ctx?.addArc(center: CGPoint(x: radius, y: top + radius), radius: radius, startAngle: (CGFloat)(Double.pi) / 2.0 * 3, endAngle: (CGFloat)(Double.pi) / 2.0 * 1.0, clockwise: true)
        ctx?.addLine(to: l_right_bottom)
        
        ctx?.addLine(to: l_right_top)
        ctx?.closePath()
        
        ctx?.fillPath()
        

        
        ctx?.setFillColor(UIColor.blue.cgColor)

        ctx?.addArc(center: CGPoint(x: rect.maxX - radius, y: top + radius), radius: radius, startAngle: (CGFloat)(Double.pi) / 2.0 * 3, endAngle: (CGFloat)(Double.pi) / 2.0 * 1.0, clockwise: false)
        ctx?.addLine(to: r_left_bottom)
        ctx?.addLine(to: r_left_top)

        ctx?.closePath()
        ctx?.fillPath()

        
    }
}
