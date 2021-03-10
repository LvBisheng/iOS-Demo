//
//  CustomTagDemoCtrl.swift
//  iOS-Demo
//
//  Created by lbs on 2021/2/24.
//  Copyright © 2021 LBS. All rights reserved.
//

import UIKit
import SnapKit

class CustomTagDemoCtrl: UIViewController {

    private lazy var tagsView: LBSTagView = {
        let tagsView = LBSTagView.init(frame: CGRect.zero)
        view.addSubview(tagsView)
        tagsView.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.size.width - 30)
            make.top.equalToSuperview().offset(100)
        }
        return tagsView
    }()
    var tags: [LBSBaseTagItemViewModel] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        tagsView.backgroundColor = UIColor.lightGray
        tagsView.delegate = self
        tagsView.dataSource = self
        // 单选
        tagsView.maxWidth = UIScreen.main.bounds.size.width - 30
        tagsView.maxSelectCount = 1
        
        var tempList: [LBSCanDeleteTagItemViewModel] = []
        for title in ["只能单选",
                      "高度不等",
                      "又酸又甜的很大的青芒",
                      "芭乐",
                      "🥕",
                      "葡萄🍇",
                      "樱桃🍒"
            ] {
                
                let model = LBSCanDeleteTagItemViewModel.init()
                model.title = title
                tempList.append(model)
                
        }
        tags.append(contentsOf: tempList)
        
        tagsView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @objc func delete(index: Int) {
        tags.remove(at: index)
        tagsView.reloadData()
    }
}

extension CustomTagDemoCtrl:  LBSTagViewDelegate, LBSTagViewDataSource {
    func tagsView(_ tagsView: LBSTagView, itemAt index: Int) -> LBSBaseTagItemView {
        let itemView = LBSCanDeleteTagItemView.init()
        let model = tags[index]
        itemView.tagModel = model
        itemView.deleteClosure = {
            [weak self] in
            guard let self = self else { return }
            self.delete(index: index)
        }
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


