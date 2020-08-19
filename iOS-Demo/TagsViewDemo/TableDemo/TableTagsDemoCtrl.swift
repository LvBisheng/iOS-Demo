//
//  TableTagsDemoCtrl.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/17.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

class TableTagsDemoCtrl: UIViewController {

    var dataSource: [TagsTableViewCellModel] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...15 {
            let cellModel = TagsTableViewCellModel.init()
            cellModel.test()
            dataSource.append(cellModel)
        }
        
        
        tableView.register(UINib.init(nibName: "TagsTableViewCell", bundle: nil), forCellReuseIdentifier: "TagsTableViewCell")

        // Do any additional setup after loading the view.
    }



}

extension TableTagsDemoCtrl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagsTableViewCell") as! TagsTableViewCell
        let model = dataSource[indexPath.row]
        cell.cellModel = model
        return cell
    }
    
}

