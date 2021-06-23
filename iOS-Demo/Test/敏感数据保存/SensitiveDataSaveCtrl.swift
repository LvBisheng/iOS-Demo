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
        
        let nsString = NSString(string: "123")
       let result = NSString(string: nsString.lbs_encryptWithAES())
        XLLog("\(result), \(result.lbs_decryptWithAES())")
        
        // Do any additional setup after loading the view.
    }

    @IBAction func query(_ sender: Any) {
        let dict = LBSKeyChainUtil.queryData(withIdentifier: kID) as? [AnyHashable: Any]
        let user = dict?["user"] as? String
        let pwd = dict?["pwd"] as? String
        userNameTF.text = NSString(string: user ?? "").lbs_decryptWithAES()
        pwdTF.text = NSString(string: pwd ?? "").lbs_decryptWithAES()
    }

    @IBAction func del(_ sender: Any) {
        LBSKeyChainUtil.deleteData(withIdentifier: kID)
    }
    
    @IBAction func save(_ sender: Any) {
        let user = userNameTF.text ?? ""
        let pwd = pwdTF.text ?? ""
        // 先对称加密再存储
        let dict = ["user": NSString(string: user).lbs_encryptWithAES(), "pwd": NSString(string: pwd).lbs_encryptWithAES()] as [String : Any]
        LBSKeyChainUtil.saveData(dict, forIdentifier: kID)
    }
    
    @IBAction func update(_ sender: Any) {
        let user = userNameTF.text ?? ""
        let pwd = pwdTF.text ?? ""
        let dict = ["user": NSString(string: user).lbs_encryptWithAES(), "pwd": NSString(string: pwd).lbs_encryptWithAES()] as [String : Any]
        LBSKeyChainUtil.updateData(dict, forIdentifier: kID)
    }
   

}
