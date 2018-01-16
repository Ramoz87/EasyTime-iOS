//
//  SettingViewHeader.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 16/01/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class SettingViewHeader: UIView {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    
    var user: ETUser? {
        didSet {
            if let user = user {
                lbName.text = user.fullName
                lbTitle.text = "Company Name"
            }
            else
            {
                lbName.text = ""
                lbTitle.text = ""
            }
        }
    }
}
