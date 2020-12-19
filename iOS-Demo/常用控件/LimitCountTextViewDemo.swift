//
//  LimitCountTextViewDemo.swift
//  iOS-Demo
//
//  Created by lbs on 2020/12/19.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class LimitCountTextViewDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let tv = XLLimiCountTextView.defaultTextView(true)
        view.addSubview(tv)
        tv.frame = CGRect(x: 15, y: 160, width: view.bounds.size.width - 30, height: 150)
        tv.textView.backgroundColor = .cyan
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
