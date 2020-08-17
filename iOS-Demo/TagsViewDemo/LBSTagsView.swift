//
//  LBSTagsView.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/17.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class LBSTagsView: UIView {
    
    var maxWidth: CGFloat = 0
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 45)
    }
    
   override func layoutSubviews() {
        print("111")
    }
    
    func removeAllTag() {
        
    }
    
    func addTag(_ tag: LBSTagsItemViewModel) {
        
    }
}

protocol LBSTagsViewItemProtocol {
    
}

class LBSTagsItemViewModel {
    
}
