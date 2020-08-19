//
//  LBSNomalTagsItemView.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/18.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class LBSNomalTagsItemView: LBSBaseTagsItemView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .cyan
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel.init()
        addSubview(titleLab)
        return titleLab
    }()
    
    override var tagModel: LBSBaseTagsItemViewModel {
        didSet {
            if let tag = tagModel as? LBSNomalTagsItemViewModel {
                titleLab.text = tag.title
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.titleLab.intrinsicContentSize.width + 10, height: self.titleLab.intrinsicContentSize.height + 10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let titleLabSize = titleLab.intrinsicContentSize
        self.titleLab.frame = CGRect(x: 5, y: 5, width: titleLabSize.width, height: titleLabSize.height)
    }

}

class LBSNomalTagsItemViewModel: LBSBaseTagsItemViewModel {
    
}

