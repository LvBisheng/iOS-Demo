//
//  SensitiveDataSaveCtrl.swift
//  iOS-Demo
//
//  Created by lbs on 2021/6/23.
//  Copyright © 2021 LBS. All rights reserved.
//

import UIKit

let kID = "com.lbs.demo.userpwd"
class SensitiveDataSaveCtrl: UIViewController {
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        query("随便写")

        // Do any additional setup after loading the view.
    }

    @IBAction func query(_ sender: Any) {
        let dict = LBSKeyChainUtil.queryData(withIdentifier: kID) as? [AnyHashable: Any]
        let user = dict?["user"] as? String
        let pwd = dict?["pwd"] as? String
        userNameTF.text = user
        pwdTF.text = pwd
    }

    @IBAction func del(_ sender: Any) {
        LBSKeyChainUtil.deleteData(withIdentifier: kID)
    }
    
    @IBAction func save(_ sender: Any) {
        let user = userNameTF.text
        let pwd = pwdTF.text
        let dict = ["user": user, "pwd": pwd]
        LBSKeyChainUtil.saveData(dict, forIdentifier: kID)
    }
    
    @IBAction func update(_ sender: Any) {
        let user = userNameTF.text
        let pwd = pwdTF.text
        let dict = ["user": user, "pwd": pwd]
        LBSKeyChainUtil.updateData(dict, forIdentifier: kID)
    }
   

}
