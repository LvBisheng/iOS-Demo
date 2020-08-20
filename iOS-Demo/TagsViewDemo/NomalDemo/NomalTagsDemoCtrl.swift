//
//  NomalTagsDemoCtrl.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/18.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class NomalTagsDemoCtrl: UIViewController {

    var tags: [LBSBaseTagsItemViewModel] = []
    @IBOutlet weak var tagsView: LBSTagsView!
    override func viewDidLoad() {
        super.viewDidLoad()
       testSingleTap()
        

        // Do any additional setup after loading the view.
    }

    func testSingleTap() {
        tagsView.backgroundColor = UIColor.lightGray
        tagsView.delegate = self
        tagsView.dataSource = self
        // 单选
        tagsView.maxWidth = UIScreen.main.bounds.size.width - 30
        tagsView.maxSelectCount = 1
        
        var tempList: [LBSNomalTagsItemViewModel] = []
        for title in ["只能单选",
                      "高度不等",
                      "又酸又甜的很大的青芒",
                      "芭乐",
                      "🥕",
                      "葡萄🍇",
                      "樱桃🍒"
            ] {
                
                let model = LBSNomalTagsItemViewModel.init()
                model.title = title
                tempList.append(model)
                
        }
        tags.append(contentsOf: tempList)
        tagsView.reloadData()
    }
}

extension NomalTagsDemoCtrl: LBSTagsViewDelegate, LBSTagsViewDataSource {
    func tagsView(_ tagsView: LBSTagsView, itemAt index: Int) -> LBSBaseTagsItemView {
        let itemView = LBSNomalTagsItemView.init()
        let model = tags[index]
        itemView.tagModel = model
        return itemView
    }
    
    func tagNumber(in tagsView: LBSTagsView) -> Int {
        return tags.count
    }
    
    func LBSTagsViewSelectedFail(view: LBSTagsView, selectedItemModel: LBSBaseTagsItemViewModel, failReason: LBSTagsViewSelectFailReaon) {
        let msg = failReason == .beyond ? "不能再选择了" : "这个不能选喔"
        UIApplication.currentViewController()?.alert(message: msg)
    }
    
    func LBSTagsViewSelected(view: LBSTagsView, selectedItemModel: LBSBaseTagsItemViewModel) {
        print("选中了\(selectedItemModel.title ?? "")")
    }
}

