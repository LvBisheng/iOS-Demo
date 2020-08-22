//
//  NomalTagsDemoCtrl.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/18.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class NomalTagsDemoCtrl: UIViewController {

    var tags: [LBSBaseTagItemViewModel] = []
    @IBOutlet weak var tagsView: LBSTagView!
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
        
        var tempList: [LBSNomalTagItemViewModel] = []
        for title in ["只能单选",
                      "高度不等",
                      "又酸又甜的很大的青芒",
                      "芭乐",
                      "🥕",
                      "葡萄🍇",
                      "樱桃🍒"
            ] {
                
                let model = LBSNomalTagItemViewModel.init()
                model.title = title
                tempList.append(model)
                
        }
        tags.append(contentsOf: tempList)
        tagsView.reloadData()
    }
}

extension NomalTagsDemoCtrl: LBSTagViewDelegate, LBSTagViewDataSource {
    func tagsView(_ tagsView: LBSTagView, itemAt index: Int) -> LBSBaseTagItemView {
        let itemView = LBSNomalTagItemView.init()
        let model = tags[index]
        itemView.tagModel = model
        return itemView
    }
    
    func tagNumber(in tagsView: LBSTagView) -> Int {
        return tags.count
    }
    
    func LBSTagViewSelectedFail(view: LBSTagView, selectedItemModel: LBSBaseTagItemViewModel, failReason: LBSTagViewSelectFailReaon) {
        let msg = failReason == .beyond ? "不能再选择了" : "这个不能选喔"
        UIApplication.currentViewController()?.alert(message: msg)
    }
    
    func LBSTagViewSelected(view: LBSTagView, selectedItemModel: LBSBaseTagItemViewModel) {
        print("选中了\(selectedItemModel.title ?? "")")
    }
}

