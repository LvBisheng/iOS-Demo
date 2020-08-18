//
//  UIViewControllerExtensions.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/18.
//  Copyright © 2020 LBS. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(message: String , title: String = "提示", cancleTitle: String = "取消" , markSureTitle: String = "确定", complete: ((Bool)->())? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancleTitle, style: .default) { (_) in
            complete?(false)
        }
        let okAction = UIAlertAction.init(title: markSureTitle, style: .default) { (alert) in
            complete?(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        var showInCtr = self
        if let nav = navigationController {
            showInCtr = nav
        }
        showInCtr.present(alertController, animated: true, completion: nil)
    }
}
