//
//  LBSTagView.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/17.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

/// 不能选中时的类型
enum LBSTagViewSelectFailReaon {
    /// 已经超过可选的数目了
    case beyond
    /// 不能选的
    case disable
}

protocol LBSTagViewDelegate: NSObjectProtocol {
    /// 选中失败时的回调
    func LBSTagViewSelectedFail(view: LBSTagView, selectedItemModel: LBSBaseTagItemViewModel, failReason: LBSTagViewSelectFailReaon)
    /// 选中标签时的回调
    func LBSTagViewSelected(view: LBSTagView, selectedItemModel: LBSBaseTagItemViewModel)
}

protocol LBSTagViewDataSource: NSObjectProtocol {
    /// 返回item的view
    func tagsView(_ tagsView: LBSTagView, itemAt index: Int) -> LBSBaseTagItemView
    /// item的个数
    func tagNumber(in tagsView: LBSTagView) -> Int
}

extension LBSTagViewDelegate {
    func LBSTagViewSelectedFail(view: LBSTagView, selectedItemModel: LBSBaseTagItemViewModel, failReason: LBSTagViewSelectFailReaon) {}
    func LBSTagViewSelected(view: LBSTagView, selectedItemModel: LBSBaseTagItemViewModel) {}
}

class LBSTagView: UIView {
    
    weak var delegate: LBSTagViewDelegate?
    weak var dataSource: LBSTagViewDataSource?

    /// 整个视图的最大宽度
    var maxWidth: CGFloat = UIScreen.main.bounds.size.width
    var itemSpacingV: CGFloat = 10; // 内部元素 垂直间距
    var itemSpacingH: CGFloat = 5; // 内部元素 水平间距
    var contentMarging: UIEdgeInsets = UIEdgeInsets.init(top: 10, left: 5, bottom: 10, right: 5)
    /// 最大选中标签的数目，等于0时，说明所有标签不可选
    var maxSelectCount = 3

    private var itemViewList: [LBSBaseTagItemView] = []
    private var itemModelList: [LBSBaseTagItemViewModel] = []
    private var selectedItemViewList: [LBSBaseTagItemView] = []
        
    /// 返回整个视图的size
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
        
        /// 最终包裹tags item所需的高度
        var needHeight = topMargin
        /// 上一行的最大Y值
        var maxItemBottomY = y
        
        
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
                y = maxItemBottomY + self.itemSpacingV
            }
            // 设置item最新的frame
            itemModel.cacheFrame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            // 设置下次的x
            x = itemModel.cacheFrame.maxX + self.itemSpacingH
            
            maxItemBottomY = max(maxItemBottomY, itemModel.cacheFrame.maxY)
            
            // 设置最新的容器高度
            needHeight = maxItemBottomY + bottomMargin
        }
        

        return CGSize(width: 0, height: needHeight)
    }
    
   override func layoutSubviews() {
        for (idx,subView) in itemViewList.enumerated() {
            
            let itemModel = itemModelList[idx]
            subView.frame = itemModel.cacheFrame
        }
        
    }
    
    func removeAllTag() {
        itemViewList.forEach { $0.removeFromSuperview() }
        itemViewList.removeAll()
        itemModelList.removeAll()
        
        selectedItemViewList.removeAll()
        
        invalidateIntrinsicContentSize()
    }
    
    @objc func itemTapAction(sender: LBSBaseTagItemView) {
        
       let currentTapModel = sender.tagModel

        if maxSelectCount <= 0 || sender.tagModel.canSelected == false {
            // 不能点击
                delegate?.LBSTagViewSelectedFail(view: self, selectedItemModel: currentTapModel, failReason: .disable)
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
                delegate?.LBSTagViewSelected(view: self, selectedItemModel: currentTapModel)
            } else { // 多选
                // 不能再选了，已经足够了
                if maxSelectCount <= selectedItemViewList.count {
                    delegate?.LBSTagViewSelectedFail(view: self, selectedItemModel: currentTapModel, failReason: .beyond)
                    return
                }
                sender.isSelected = true
                sender.tagModel.isSelected = true
                selectedItemViewList.append(sender)
                delegate?.LBSTagViewSelected(view: self, selectedItemModel: currentTapModel)
            }
        }
    }
}

extension LBSTagView {
    func reloadData() {
        
        removeAllTag()
        let count = dataSource?.tagNumber(in: self) ?? 0
        for idx in 0..<count {
            let itemView = dataSource?.tagsView(self, itemAt: idx) ?? LBSBaseTagItemView.init()
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
}

/// 需要自定义item 时要继承这个view
class LBSBaseTagItemView: UIControl {
    var tagModel: LBSBaseTagItemViewModel = LBSBaseTagItemViewModel.init()
}

class LBSBaseTagItemViewModel {
    /// 缓存item的frame值。外部适用时不要去变更它
    var cacheFrame: CGRect = .zero
    var isSelected: Bool = false
    var canSelected: Bool = true
    var title: String?
}
