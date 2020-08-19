//
//  TagsTableViewCell.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/17.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class TagsTableViewCell: UITableViewCell {
    @IBOutlet weak var tagsView: LBSTagsView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var contentLab: UILabel!
    
    var cellModel: TagsTableViewCellModel? {
        didSet {
            titleLab.text = cellModel?.title
            contentLab.text = cellModel?.content
            self.tagsView.removeAllTag()
            let list = cellModel?.list
            list?.forEach({ (subModel) in
                self.tagsView.addTag(subModel)
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagsView.maxWidth = UIScreen.main.bounds.size.width - 30
        tagsView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TagsTableViewCell: LBSTagsViewDelegate {
    func LBSTagsViewSelectedFail(view: LBSTagsView, selectedItemModel: LBSBaseTagsItemViewModel, failReason: LBSTagsViewSelectFailReaon) {
        let msg = failReason == .beyond ? "不能再选择了" : "这个不能选喔"
        UIApplication.currentViewController()?.alert(message: msg)
    }
    
    func LBSTagsViewSelected(view: LBSTagsView, selectedItemModel: LBSBaseTagsItemViewModel) {
        UIApplication.currentViewController()?.alert(message: "选中了:\(selectedItemModel.title ?? "")")
    }
}

class TagsTableViewCellModel {
    var title: String?
    var list: [LBSBaseTagsItemViewModel] = []
    var content: String?
    
    func test() {
        let num = arc4random() % 4
        var count = 8
        if num == 1 {
            count = 15
            title = "15个标签"
            content = "内容不多"
        } else if num == 0 {
            count = 2
            title = "2个标签"
            content = "内容很多: App Store 的指导原则非常简单 - 我们希望为用户获取 app 时提供更安全可靠的体验，并为所有开发者提供借助 app 获得成功的契机。为此，我们精心打造了 App Store，其中的每个 app 都会经过专家审核，而且还有编辑团队每天帮助广大用户发现新的 app。至于别的一切，可以考虑在开放的互联网上分享。如果 App Store 模式和准则与您的 app 或经营理念不能完美契合，那也没关系，我们的 Safari 浏览器也能提供出色的 Web 体验。"
        } else if num == 3 {
            count = 4
            title = "4个标签"
            content = "很多儿童会从我们这里大量下载各种 app。尽管家长控制功能能为儿童提供有效保护，但您也必须做好自己份内的工作。因此，您要知道，我们时刻都在关注这些儿童"
        }
        else {
            count = 25
            title = "25个标签"
            content = "确保所有 app 信息及元数据完整且正确"
        }
        
        for idx in 0...count {
            let item = LBSBaseTagsItemViewModel.init()
            if idx % 2 == 0 {
                if idx % 3 == 0 {
                    item.title = "一个人的厨房"
                } else {
                    item.title = "iPhone"
                }
            } else {
                if idx % 5 == 0 {
                    item.title = "晒晒👍"
                } else {
                    item.title = "奥特曼打小怪兽"
                }
            }
            list.append(item)
        }
    }
}
