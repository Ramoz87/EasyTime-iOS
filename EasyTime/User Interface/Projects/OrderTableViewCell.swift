//
//  OrderTableViewCell.swift
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

class OrderTableViewCell: UITableViewCell {

    static let reuseIdentifier = "OrderTableViewCellReuseIdentifier"
    static let cellName = "OrderTableViewCell"
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    
    var order: ETOrder? {
        
        didSet {
            
            if let order = order {
                
                self.lblID.text = order.number
                self.lblName.text = order.name

                self.lblAddress.text = ""
                self.lblAddress.text?.append(order.deliveryAddress?.country, separator: Constants.addressSeparator)
                self.lblAddress.text?.append(order.deliveryAddress?.city, separator: Constants.addressSeparator)
                self.lblAddress.text?.append(order.deliveryAddress?.street, separator: Constants.addressSeparator)
                self.lblAddress.text?.append(order.deliveryAddress?.zip, separator: Constants.addressSeparator)
                self.lblAddress.text?.append(order.deliveryTime, separator: Constants.addressSeparator)
            }
        }
    }
}
