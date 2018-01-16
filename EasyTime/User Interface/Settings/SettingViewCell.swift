//
//  SettingViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 16/01/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class SettingViewCell: UITableViewCell {

    static let reuseIdentifier = "SettingViewCellReuseIdentifier"
    static let cellName = "SettingViewCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    var settingItem: SettingItem? {
        didSet {
            if let item = settingItem {
                icon.image = item.icon
                title.text = item.title
            }
        }
    }
}
