//
//  ProjectTableViewCell.swift
//  EasyTime
//
//  Created by Mobexs on 12/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ProjectTableViewCellReuseIdentifier"
    static let cellName = "ProjectTableViewCell"

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!

    var project: ETProject? {

        didSet {

            if let project = project {

                self.lblID.text = project.number
                self.lblName.text = project.name
                self.lblCompanyName.text = project.customer?.companyName
            }
        }
    }
}
