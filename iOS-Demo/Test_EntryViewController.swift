//
//  Test_EntryViewController.swift
//  iOS-Demo
//
//  Created by lbs on 2020/8/17.
//  Copyright © 2020 LBS. All rights reserved.
//

import UIKit

struct Test_CellModel {
    var name: String?
    var tapBlock: (()->(Void))?
    init(name: String?, tapBlock: (()->(Void))?) {
        self.name = name
        self.tapBlock = tapBlock
    }
}

private let cellId = "cellId"

class Test_EntryViewController: UIViewController {
    
    var dataSource: [Test_CellModel] = []
    /// 第一级
    var firstTest: Bool = true
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.frame = self.view.bounds
        if firstTest {
            firstTestConfig()
        }
        
    }
    
    
    
    private func firstTestConfig() {
        
        dataSource.append(contentsOf: self.other())
    }
    
}

extension Test_EntryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        cell.textLabel?.text = dataSource[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataSource[indexPath.row]
        if let block = model.tapBlock {
            block()
        }
    }
}


