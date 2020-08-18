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
    func LBSTagsViewSelectedFail(view: LBSTagsView, selectedItemModel: LBSTagsItemViewModel, failReason: LBSTagsViewSelectFailReaon)
    func LBSTagsViewSelected(view: LBSTagsView, selectedItemModel: LBSTagsItemViewModel)
}

extension LBSTagsViewDelegate {
    func LBSTagsViewSelectedFail(view: LBSTagsView, selectedItemModel: LBSTagsItemViewModel, failReason: LBSTagsViewSelectFailReaon) {}
    func LBSTagsViewSelected(view: LBSTagsView, selectedItemModel: LBSTagsItemViewModel) {}
}

class LBSTagsView: UIView {
    
    weak var delegate: LBSTagsViewDelegate?

    
    var maxWidth: CGFloat = 0
    private var itemViewList: [LBSTagsItemView] = []
    private var itemModelList: [LBSTagsItemViewModel] = []
    private var selectedItemViewList: [LBSTagsItemView] = []
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
    
    func setTags(_ tags: [LBSTagsItemViewModel]) {
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
    
    func addTag(_ tag: LBSTagsItemViewModel) {
        let itemView = LBSTagsItemView.init()
        addSubview(itemView)
        itemView.model = tag
        itemViewList.append(itemView)
        itemModelList.append(tag)
        if tag.isSelected && selectedItemViewList.count < self.maxSelectCount {
            selectedItemViewList.append(itemView)
        }
        
        itemView.addTarget(self, action: #selector(itemTapAction(sender:)), for: .touchUpInside)
        
        invalidateIntrinsicContentSize()
    }
    
    @objc func itemTapAction(sender: LBSTagsItemView) {
        
        guard let currentTapModel = sender.model else {
            return
        }

        if maxSelectCount <= 0 || sender.model?.canSelected == false {
            // 不能点击
                delegate?.LBSTagsViewSelectedFail(view: self, selectedItemModel: currentTapModel, failReason: .disable)
            return;
        }
        
        // 是否准备取消选中状态（原来是选中的）
        let isToUnSelected = sender.isSelected
        if isToUnSelected == true {
            // 1.要设置为不选中
            
            sender.isSelected = false
            sender.model?.isSelected = false
            selectedItemViewList.removeAll { (subView) -> Bool in
                return subView === sender
            }
        } else {
            // 2.想设置为选中
            if maxSelectCount == 1 { // 单选
                // 置反以前的
                if let preItem = selectedItemViewList.first {
                    preItem.isSelected = false
                    preItem.model?.isSelected = false
                    selectedItemViewList.removeAll { (subView) -> Bool in
                        return subView === preItem
                    }
                }
                // 选中当前的
                sender.isSelected = true
                sender.model?.isSelected = true
                selectedItemViewList.append(sender)
                delegate?.LBSTagsViewSelected(view: self, selectedItemModel: currentTapModel)
            } else { // 多选
                // 不能再选了，已经足够了
                if maxSelectCount <= selectedItemViewList.count {
                    delegate?.LBSTagsViewSelectedFail(view: self, selectedItemModel: currentTapModel, failReason: .beyond)
                    return
                }
                sender.isSelected = true
                sender.model?.isSelected = true
                selectedItemViewList.append(sender)
                delegate?.LBSTagsViewSelected(view: self, selectedItemModel: currentTapModel)
            }
        }
    }
}



protocol LBSTagsViewItemProtocol where Self: UIView {
    
}

class LBSTagsItemViewModel {
    var cacheFrame: CGRect = .zero
    var isSelected: Bool = false
    var canSelected: Bool = true
    
    var title: String?
}
