//
//  LBSTagViewItem.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/17.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class LBSTagsItemView: LBSBaseTagItemView {
    
    private var titeLabFrame = CGRect.zero
    private var iconImgvFrame = CGRect.zero

    override var tagModel: LBSBaseTagItemViewModel {
        didSet {
            self.isSelected = tagModel.isSelected ?? false
            titleLab.text = tagModel.title
        }
    }
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel.init()
        addSubview(titleLab)
        return titleLab
    }()
    
    lazy var iconImgv: UIImageView = {
        let iconImgv = UIImageView.init()
        addSubview(iconImgv)
        iconImgv.image = UIImage.init(named: "biaoqian")
        return iconImgv
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = .orange
            } else {
                self.backgroundColor = UIColor.init(hexString: "#BCBCBC")!
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImgv.frame = iconImgvFrame
        titleLab.frame = titeLabFrame
    }
    
    override var intrinsicContentSize: CGSize {
        let selfHeight: CGFloat = 30
        iconImgvFrame = CGRect(x: 5, y: (selfHeight - 10) * 0.5, width: 10, height: 10)
        titeLabFrame = CGRect(x: iconImgvFrame.maxX + 5, y: 0, width: titleLab.intrinsicContentSize.width, height: selfHeight)
        return CGSize(width: titeLabFrame.maxX, height: titeLabFrame.maxY)
    }
}
