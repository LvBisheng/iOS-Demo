//
//  SensitiveDataSaveCtrl.swift
//  iOS-Demo
//
//  Created by lbs on 2021/6/23.
//  Copyright © 2021 LBS. All rights reserved.
//

import UIKit

let kID = "com.lbs.demo.userpwd"
class TestSecurityCtrl: UIViewController {
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    
    /// 明文输入框
    @IBOutlet weak var RSAMingWenTF: UITextField!
    /// 密文
    @IBOutlet weak var RSAMiWenTF: UITextField!
    /// 解密之后的数据
    @IBOutlet weak var RSAJieMiTF: UITextField!
    
    @IBOutlet weak var waitHashTF: UITextField!
    @IBOutlet weak var doneHashTF: UITextField!
    
    let AESKey = "abc"
    private lazy var IVData: Data = {
        let AESIV: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8]
        let data = Data.init(bytes: AESIV, count: AESIV.count)
        return data
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        query("随便写")
        
        //1.加载公钥
        LBSRSACryptor.shared().loadPublicKey(Bundle.main.path(forResource: "rsacert.der", ofType: nil))
        //2.加载私钥
        LBSRSACryptor.shared().loadPrivateKey(Bundle.main.path(forResource: "p.p12", ofType: nil), password: "123456")
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension TestSecurityCtrl {
    @IBAction func query(_ sender: Any) {
        let dict = LBSKeyChainUtil.queryData(withIdentifier: kID) as? [AnyHashable: Any]
        let user = dict?["user"] as? String
        let pwd = dict?["pwd"] as? String
        userNameTF.text =  LBSEncryptionTools.shared().decryptString(user ?? "", keyString: AESKey, iv: IVData)
        pwdTF.text = LBSEncryptionTools.shared().decryptString(pwd ?? "", keyString: AESKey, iv: IVData)
    }

    @IBAction func del(_ sender: Any) {
        LBSKeyChainUtil.deleteData(withIdentifier: kID)
    }
    
    @IBAction func save(_ sender: Any) {
        let user = userNameTF.text ?? ""
        let pwd = pwdTF.text ?? ""
        // 先对称加密再存储
        let userResult = LBSEncryptionTools.shared().encryptString(user, keyString: AESKey, iv: IVData) ?? ""
        let pwdResult = LBSEncryptionTools.shared().encryptString(pwd, keyString: AESKey, iv: IVData) ?? ""
        let dict = ["user": userResult, "pwd": pwdResult] as [String : Any]
        LBSKeyChainUtil.saveData(dict, forIdentifier: kID)
    }
    
    @IBAction func update(_ sender: Any) {
        let user = userNameTF.text ?? ""
        let pwd = pwdTF.text ?? ""
        let userResult = LBSEncryptionTools.shared().encryptString(user, keyString: AESKey, iv: IVData) ?? ""
        let pwdResult = LBSEncryptionTools.shared().encryptString(pwd, keyString: AESKey, iv: IVData) ?? ""
        let dict = ["user": userResult, "pwd": pwdResult] as [String : Any]
        LBSKeyChainUtil.updateData(dict, forIdentifier: kID)
    }
}

extension TestSecurityCtrl {
    // RSA加解密
    @IBAction func rsa(_ sender: Any) {
        view.endEditing(true)
        
        let text = RSAMingWenTF.text
        if let data = text?.data(using: String.Encoding.utf8) {
            guard let miwenData = LBSRSACryptor.shared().encryptData(data) else {
                return
            }
            // 展示加密过后的base64数据
            RSAMiWenTF.text = miwenData.base64EncodedString()
        }

        
        let miwenText = RSAMiWenTF.text
        if let miwenData = Data.init(base64Encoded: miwenText ?? "") {
            guard let jimiData = LBSRSACryptor.shared().decryptData(miwenData) else {
                return
            }
            // 展示解密后的数据
            RSAJieMiTF.text = String.init(data: jimiData, encoding: String.Encoding.utf8)
        }
    }
    
}

extension TestSecurityCtrl {
    @IBAction func hmac(_ sender: Any) {
        view.endEditing(true)

        let pwd = waitHashTF.text ?? ""
        doneHashTF.text = NSString(string: pwd).hmacMD5String(withKey: "hank") // key一般是服务器给的
    }
}
