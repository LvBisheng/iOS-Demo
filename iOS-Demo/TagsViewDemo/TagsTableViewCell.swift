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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagsView.maxWidth = UIScreen.main.bounds.size.width - 30
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
