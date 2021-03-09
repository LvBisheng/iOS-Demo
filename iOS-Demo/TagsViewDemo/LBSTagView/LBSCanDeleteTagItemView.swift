//
//  LBSCanDeleteTagItemView.swift
//  iOS-Demo
//
//  Created by lbs on 2021/2/24.
//  Copyright © 2021 LBS. All rights reserved.
//

import UIKit

class LBSCanDeleteTagItemView: LBSBaseTagItemView {

    var deleteClosure: (()->())?
    
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
    
    private(set) lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton.init()
        deleteBtn.setTitle("X", for: .normal)
        deleteBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        addSubview(deleteBtn)
        deleteBtn.backgroundColor = .red
        deleteBtn.addTarget(self, action:#selector(deleteAcction), for: .touchUpInside)
        return deleteBtn
    }()
    
    @objc func deleteAcction() {
        deleteClosure?()
    }
    
    override var tagModel: LBSBaseTagItemViewModel {
        didSet {
            if let tag = tagModel as? LBSCanDeleteTagItemViewModel {
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
            if let tag = tagModel as? LBSCanDeleteTagItemViewModel {
                backgroundColor = isSelected ? tag.selectedBackgroudColor : tag.nomalBackgroudColor
                titleLab.textColor = isSelected ? tag.selectedTextColor : tag.nomalTextColor
                layer.borderColor = isSelected ? tag.selectedBorderColor.cgColor : tag.normalBorderColor.cgColor
            }
        }
    }
    
    /// 返回item对应的尺寸。这里很重要
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.titleLab.intrinsicContentSize.width + 10 + deleteBtn.bounds.width, height: self.titleLab.intrinsicContentSize.height + 10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLab.frame = CGRect(x: 0, y: 0, width: self.intrinsicContentSize.width - deleteBtn.bounds.width, height: self.intrinsicContentSize.height)
        deleteBtn.frame = CGRect(x: titleLab.frame.maxX, y: 0, width: deleteBtn.bounds.size.width, height: deleteBtn.bounds.size.height)
    }

}

class LBSCanDeleteTagItemViewModel: LBSBaseTagItemViewModel {
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

