//
//  LBSNomalTagItemView.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/18.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class LBSNomalTagItemView: LBSBaseTagItemView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel.init()
        addSubview(titleLab)
        titleLab.textAlignment = .center
        return titleLab
    }()
    
    override var tagModel: LBSBaseTagItemViewModel {
        didSet {
            if let tag = tagModel as? LBSNomalTagItemViewModel {
                titleLab.text = tag.title
                layer.cornerRadius = tag.cornerRadius
                layer.borderWidth = tag.borderWidth
                self.isSelected = tag.isSelected
            }
        }
    }
    
    /// 根据选中与否来设置对应的UI
    override var isSelected: Bool {
        didSet {
            if let tag = tagModel as? LBSNomalTagItemViewModel {
                backgroundColor = isSelected ? tag.selectedBackgroudColor : tag.nomalBackgroudColor
                titleLab.textColor = isSelected ? tag.selectedTextColor : tag.nomalTextColor
                layer.borderColor = isSelected ? tag.selectedBorderColor.cgColor : tag.normalBorderColor.cgColor
            }
        }
    }
    
    /// 返回item对应的尺寸。这里很重要
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.titleLab.intrinsicContentSize.width + 10, height: self.titleLab.intrinsicContentSize.height + 10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLab.frame = self.bounds
    }

}

/// 普通的标签item
class LBSNomalTagItemViewModel: LBSBaseTagItemViewModel {
    var font: UIFont = .systemFont(ofSize: 12)
    
    var selectedTextColor = UIColor.white
    var selectedBackgroudColor = UIColor.orange
    
    var nomalTextColor = UIColor.darkGray
    var nomalBackgroudColor = UIColor.white
    
    var cornerRadius: CGFloat = 5.0
    var normalBorderColor = UIColor.darkGray
    var selectedBorderColor = UIColor.darkGray
    var borderWidth: CGFloat = 0.5
}

