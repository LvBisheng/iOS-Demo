//
//  NomalTagsDemoCtrl.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/18.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class NomalTagsDemoCtrl: UIViewController {

    @IBOutlet weak var tagsView: LBSTagsView!
    override func viewDidLoad() {
        super.viewDidLoad()
       testSingleTap()
        

        // Do any additional setup after loading the view.
    }

    func testSingleTap() {
        // 单选
        tagsView.maxWidth = UIScreen.main.bounds.size.width - 30
        tagsView.maxSelectCount = 1
        let model0 = LBSTagsItemViewModel.init()
        model0.title = "胡萝卜🥕"
        
        let model1 = LBSTagsItemViewModel.init()
        model1.title = "非常好吃的荔枝"
        
        let model2 = LBSTagsItemViewModel.init()
        model2.title = "又酸又甜的很大的青芒"
        
        let model3 = LBSTagsItemViewModel.init()
        model3.title = "芭乐"
        
        var tempList: [LBSTagsItemViewModel] = []
        tempList.append(model0)
        tempList.append(model1)
        tempList.append(model2)
        tempList.append(model3)
        
        tagsView.setTags(tempList)
    }
}

extension NomalTagsDemoCtrl: LBSTagsViewDelegate {
    func LBSTagsViewSelectedFail(view: LBSTagsView, selectedItemModel: LBSTagsItemViewModel, failReason: LBSTagsViewSelectFailReaon) {
        let msg = failReason == .beyond ? "不能再选择了" : "这个不能选喔"
        UIApplication.currentViewController()?.alert(message: msg)
    }
    
    func LBSTagsViewSelected(view: LBSTagsView, selectedItemModel: LBSTagsItemViewModel) {
        UIApplication.currentViewController()?.alert(message: "选中了:\(selectedItemModel.title ?? "")")
    }
}
