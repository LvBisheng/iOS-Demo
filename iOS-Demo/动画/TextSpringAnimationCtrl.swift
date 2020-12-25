//
//  TextSpringAnimationCtrl.swift
//  iOS-Demo
//
//  Created by lbs on 2020/12/25.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class TextSpringAnimationCtrl: UIViewController {

    @IBOutlet weak var stiffnessSlider: UISlider!
    @IBOutlet weak var stiffnessLab: UILabel!
    
    
    @IBOutlet weak var durationLab: UILabel!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var durationSlider: UISlider!
    
    @IBOutlet weak var massLab: UILabel!
    @IBOutlet weak var massSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()

        durationChange(durationSlider as Any)
        massChange(massSlider as Any)
        stiffnessChange(stiffnessSlider as Any)

        // Do any additional setup after loading the view.
    }


    @IBAction func durationChange(_ sender: Any) {
        durationLab.text = String(format: "duration: %.0f (动画时长)", durationSlider.value)
    }
    @IBAction func massChange(_ sender: Any) {
        massLab.text = String(format: "mass: %.0f (质量。影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大)", massSlider.value)
    }
    
    @IBAction func stiffnessChange(_ sender: Any) {
        stiffnessLab.text = String(format: "stiffness: %.0f (刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快", stiffnessSlider.value)
    }
    
    @IBAction func start(_ sender: Any) {
        let spring = CASpringAnimation.init()
        spring.duration = CFTimeInterval(durationSlider.value);
        spring.keyPath = "transform.translation.y"
        spring.fromValue = 1000
        spring.mass = CGFloat(massSlider.value)
        spring.stiffness = CGFloat(stiffnessSlider.value)
//            spring.toValue = 50.0
        spring.isRemovedOnCompletion = true // 动画执行完毕后是否从图层上移除，默认为YES（视图会恢复到动画前的状态），可设置为NO（图层保持动画执行后的状态，前提是fillMode设置为kCAFillModeForwards）
        redView.layer.add(spring, forKey: nil)
    }
    
}
