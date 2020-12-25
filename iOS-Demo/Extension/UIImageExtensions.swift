//
//  UIImageExtensions.swift
//  iOS-Demo
//
//  Created by lbs on 2020/12/9.
//  Copyright © 2020 LBS. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {

    ///  Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)

        defer {
            UIGraphicsEndImageContext()
        }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }

        self.init(cgImage: aCgImage)
    }

}


extension UIImage {
   
    func resizedImge(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        var newImg = UIImage.init(cgImage: self.cgImage!, scale: 1, orientation: self.imageOrientation)
        newImg.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        if let content = UIGraphicsGetImageFromCurrentImageContext() {
            newImg = content
        }
        UIGraphicsEndImageContext()
        return newImg
    }
}
