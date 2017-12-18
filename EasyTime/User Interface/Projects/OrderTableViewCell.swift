//
//  OrderTableViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 18/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    static let reuseIdentifier = "OrderTableViewCellReuseIdentifier"
    static let cellName = "OrderTableViewCell"
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    
    var order: ETOrder? {
        
        didSet {
            
            if let order = order {
                
                self.lblID.text = order.jobId
                self.lblName.text = order.name
            }
        }
    }
    
}
