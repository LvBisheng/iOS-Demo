//
//  LBSTagsView.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/17.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

enum LBSTagsViewSelectFailReaon {
    case beyond
    case disable
}

protocol LBSTagsViewDelegate: NSObjectProtocol {
    func LBSTagsViewSelectedFail(view: LBSTagsView, selectedItemModel: LBSBaseTagsItemViewModel, failReason: LBSTagsViewSelectFailReaon)
    func LBSTagsViewSelected(view: LBSTagsView, selectedItemModel: LBSBaseTagsItemViewModel)
}

protocol LBSTagsViewDataSource: NSObjectProtocol {
    func tagsView(_ tagsView: LBSTagsView, itemAt index: Int) -> LBSBaseTagsItemView
    func tagNumber(in tagsView: LBSTagsView) -> Int
}

extension LBSTagsViewDelegate {
    func LBSTagsViewSelectedFail(view: LBSTagsView, selectedItemModel: LBSBaseTagsItemViewModel, failReason: LBSTagsViewSelectFailReaon) {}
    func LBSTagsViewSelected(view: LBSTagsView, selectedItemModel: LBSBaseTagsItemViewModel) {}
}

class LBSTagsView: UIView {
    
    weak var delegate: LBSTagsViewDelegate?
    weak var dataSource: LBSTagsViewDataSource?

    
    var maxWidth: CGFloat = 0
    private var itemViewList: [LBSBaseTagsItemView] = []
    private var itemModelList: [LBSBaseTagsItemViewModel] = []
    private var selectedItemViewList: [LBSBaseTagsItemView] = []
    var itemSpacingV: CGFloat = 10; // 内部元素 垂直间距
    var itemSpacingH: CGFloat = 5; // 内部元素 水平间距
    var contentMarging: UIEdgeInsets = UIEdgeInsets.init(top: 10, left: 5, bottom: 10, right: 5)
    var maxSelectCount = 3
    
    override var intrinsicContentSize: CGSize {
        
        guard itemViewList.count >= 0, itemModelList.count > 0 else {
            return CGSize.zero
        }
        
        let leftMargin = self.contentMarging.left
        let rightMargin = self.contentMarging.right
        let topMargin = self.contentMarging.top
        let bottomMargin = self.contentMarging.bottom
        var x = leftMargin
        var y = topMargin
        
        var needHeight = topMargin
        
        
        for (idx,subView) in itemViewList.enumerated() {
            
            let itemModel = itemModelList[idx]
            let itemSize = subView.intrinsicContentSize
            
            // 当前item最右边的x值
            var preItemRight: CGFloat = x + itemSize.width + rightMargin
            if idx != 0 {
                // 加上item之间的间距
                preItemRight += self.itemSpacingH
            }
            
            // 容不下，需要换行
            if preItemRight > self.maxWidth {
                x = leftMargin
                y = y + itemSize.height + self.itemSpacingV
            }
            // 设置item最新的frame
            itemModel.cacheFrame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            // 设置下次的x
            x = itemModel.cacheFrame.maxX + self.itemSpacingH
            
            // 设置最新的容器高度
            let preMaxY = itemModelList[max(idx - 1, 0)].cacheFrame.maxY
            needHeight = max(itemModel.cacheFrame.maxY, preMaxY) + bottomMargin
        }
        

        return CGSize(width: 0, height: needHeight)
    }
    
   override func layoutSubviews() {
        for (idx,subView) in itemViewList.enumerated() {
            
            let itemModel = itemModelList[idx]
            subView.frame = itemModel.cacheFrame
        }
        
    }
    
    func setTags(_ tags: [LBSBaseTagsItemViewModel]) {
        removeAllTag()
        tags.forEach { (subModel) in
            addTag(subModel)
        }
    }
    
    func removeAllTag() {
        itemViewList.forEach { $0.removeFromSuperview() }
        itemViewList.removeAll()
        itemModelList.removeAll()
        
        selectedItemViewList.removeAll()
        
        invalidateIntrinsicContentSize()
    }
    
    func addTag(_ tag: LBSBaseTagsItemViewModel) {
        let itemView = LBSBaseTagsItemView.init()
        addSubview(itemView)
        itemView.tagModel = tag
        itemViewList.append(itemView)
        itemModelList.append(tag)
        if tag.isSelected && selectedItemViewList.count < self.maxSelectCount {
            selectedItemViewList.append(itemView)
        }
        
        itemView.addTarget(self, action: #selector(itemTapAction(sender:)), for: .touchUpInside)
        
        invalidateIntrinsicContentSize()
    }
    
    func reloadData() {
        
        removeAllTag()
        let count = dataSource?.tagNumber(in: self) ?? 0
        for idx in 0..<count {
            let itemView = dataSource?.tagsView(self, itemAt: idx) ?? LBSBaseTagsItemView.init()
            addSubview(itemView)
            itemViewList.append(itemView)
            
            itemModelList.append(itemView.tagModel)
            if itemView.tagModel.isSelected && selectedItemViewList.count < self.maxSelectCount {
                selectedItemViewList.append(itemView)
            }
            
            itemView.addTarget(self, action: #selector(itemTapAction(sender:)), for: .touchUpInside)
            
            invalidateIntrinsicContentSize()
        }
    }
    
    @objc func itemTapAction(sender: LBSBaseTagsItemView) {
        
       let currentTapModel = sender.tagModel

        if maxSelectCount <= 0 || sender.tagModel.canSelected == false {
            // 不能点击
                delegate?.LBSTagsViewSelectedFail(view: self, selectedItemModel: currentTapModel, failReason: .disable)
            return;
        }
        
        // 是否准备取消选中状态（原来是选中的）
        let isToUnSelected = sender.isSelected
        if isToUnSelected == true {
            // 1.要设置为不选中
            
            sender.isSelected = false
            sender.tagModel.isSelected = false
            selectedItemViewList.removeAll { (subView) -> Bool in
                return subView === sender
            }
        } else {
            // 2.想设置为选中
            if maxSelectCount == 1 { // 单选
                // 置反以前的
                if let preItem = selectedItemViewList.first {
                    preItem.isSelected = false
                    preItem.tagModel.isSelected = false
                    selectedItemViewList.removeAll { (subView) -> Bool in
                        return subView === preItem
                    }
                }
                // 选中当前的
                sender.isSelected = true
                sender.tagModel.isSelected = true
                selectedItemViewList.append(sender)
                delegate?.LBSTagsViewSelected(view: self, selectedItemModel: currentTapModel)
            } else { // 多选
                // 不能再选了，已经足够了
                if maxSelectCount <= selectedItemViewList.count {
                    delegate?.LBSTagsViewSelectedFail(view: self, selectedItemModel: currentTapModel, failReason: .beyond)
                    return
                }
                sender.isSelected = true
                sender.tagModel.isSelected = true
                selectedItemViewList.append(sender)
                delegate?.LBSTagsViewSelected(view: self, selectedItemModel: currentTapModel)
            }
        }
    }
}

class LBSBaseTagsItemView: UIControl {
    var tagModel: LBSBaseTagsItemViewModel = LBSBaseTagsItemViewModel.init()
}


protocol LBSTagsViewItemProtocol where Self: UIView {
    
}

class LBSBaseTagsItemViewModel {
    var cacheFrame: CGRect = .zero
    var isSelected: Bool = false
    var canSelected: Bool = true
    
    var title: String?
}
