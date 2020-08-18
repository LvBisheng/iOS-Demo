//
//  StringExtension.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/18.
//  Copyright © 2020 LBS. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func stringSize(with font: UIFont, size: CGSize) -> CGSize {
        // 默认段落样式
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        return self.stringSize(with: font, paragrapStyle: style, size: size)
    }
    
    // 根据字符串的字体和size(此处size设置为字符串宽和MAXFLOAT)返回多行显示时的字符串size, 增加段落样式
    func stringSize(with font: UIFont, paragrapStyle: NSParagraphStyle, size: CGSize) -> CGSize {
        
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragrapStyle]
        return self.stringSize(with: attributes, size: size)
    }
    
    // 返回attributeString的尺寸
    func stringSize(with attributes: [NSAttributedString.Key: Any], size: CGSize) -> CGSize {
        
        let rect = (self as NSString).boundingRect(with: size, options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.usesLineFragmentOrigin.rawValue
        ), attributes: attributes, context: nil)
        return rect.size
    }
}
