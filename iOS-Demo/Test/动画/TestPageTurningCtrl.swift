//
//  TestPageTurningCtrl.swift
//  iOS-Demo
//
//  Created by lbs on 2021/3/9.
//  Copyright © 2021 LBS. All rights reserved.
//

import UIKit
/// 翻页动画
class TestPageTurningCtrl: UIViewController {

  
    var imgList = ["test_0", "test_1", "test_2"]
    var index = 0
    
    @IBOutlet weak var bgImgv: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImgv.image = UIImage(named: imgList[index])
        
    }
    @IBAction func pre(_ sender: Any) {
        index = index - 1
        if(index < 0) {
            index = imgList.count - 1
        }
        bgImgv.image = UIImage(named: imgList[index])
        
        let transion = CATransition.init()
        transion.type = CATransitionType.init(rawValue: "pageUnCurl")
        transion.subtype = .fromLeft
        transion.duration = 1.5
        self.bgImgv.layer.add(transion, forKey: nil)
    }
    
    @IBAction func next(_ sender: Any) {
//        index = index + 1
//        if(index >= imgList.count) {
//            index = 0
//        }
//        bgImgv.image = UIImage(named: imgList[index])
        
        let transion = CATransition.init()
        transion.type = CATransitionType.init(rawValue: "pageCurl")
        transion.subtype = .fromRight
        transion.duration = 1.5
        transion.delegate = self
        transion.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.bgImgv.layer.add(transion, forKey: nil)
    }
    
    func changeImge() {
        
        
    }
}

extension TestPageTurningCtrl: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    
    }
}
