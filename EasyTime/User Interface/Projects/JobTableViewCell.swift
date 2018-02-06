//
//  ObjectTableViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 18/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let addressSeparator = ", "
}

class JobTableViewCell: UITableViewCell {

    static let reuseIdentifier = "JobTableViewCellReuseIdentifier"
    static let cellName = "JobTableViewCell"
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    
    var job: ETJob? {
        
        didSet {
            
            if let job = job {
                
                self.lblName.text = job.name
                self.lblCompanyName.text = job.customer?.companyName
            }
        }
    }

}
