//
//  TestUIKitViewController.swift
//  iOS-Demo
//
//  Created by lbs on 2020/12/9.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class TestUIKitViewController: UIViewController {

    private lazy var bgScrollView: UIScrollView = {
        let bgScrollView = UIScrollView.init()
        bgScrollView.frame = self.view.bounds
        view.addSubview(bgScrollView)
        return bgScrollView
    }()
    
    var lastView: UIView?
    
    var lastViewMaxY: CGFloat {
        get {
            return self.lastView?.frame.maxY ?? 15
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        testSegment()
        testSlider()
    }
    

    func testSegment() {
        let segment = UISegmentedControl.init(items: ["我审核的","我发起的"])
        bgScrollView.addSubview(segment)
        segment.frame = CGRect(x: 15, y: lastViewMaxY + 20, width: 166, height: 30)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .normal)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .selected)

        let selectedColor = UIColor(hexString: "#FFD096")!
        if #available(iOS 13.0, *) {
            let nomalColor = UIColor.white
            let nomalImg = UIImage.init(color: nomalColor, size: segment.bounds.size)
            let selectedImg = UIImage.init(color: selectedColor, size: segment.bounds.size)
            segment.setBackgroundImage(nomalImg, for: .normal, barMetrics: UIBarMetrics.default)
            segment.setBackgroundImage(selectedImg, for: .selected, barMetrics: UIBarMetrics.default)
            segment.layer.borderWidth = 1
            segment.layer.borderColor = selectedColor.cgColor
        } else {
            segment.tintColor = selectedColor
        }
        segment.selectedSegmentIndex = 0
        
        lastView = segment
        bgScrollView.contentSize = CGSize(width: view.bounds.size.width, height: segment.frame.maxY)
    }
  
    func testSlider() {
        let slider = XLCustomSlider.init()
        slider.customHeight = 10
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .gray
        bgScrollView.addSubview(slider)
        slider.frame = .init(x: 15, y: lastViewMaxY + 20, width: view.bounds.size.width - 30, height: 0)
        
        lastView = slider
        bgScrollView.contentSize = .init(width: view.bounds.size.width, height: slider.frame.maxY)
    }

}
