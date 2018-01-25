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

class ObjectTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ObjectTableViewCellReuseIdentifier"
    static let cellName = "ObjectTableViewCell"
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    
    var object: ETObject? {
        
        didSet {
            
            if let object = object {
                
                self.lblID.text = object.number
                self.lblName.text = object.name
                // TODO: Set lblStatus text

                self.lblAddress.text = ""
                self.lblAddress.text?.append(object.address?.country, separator: Constants.addressSeparator)
                self.lblAddress.text?.append(object.address?.city, separator: Constants.addressSeparator)
                self.lblAddress.text?.append(object.address?.street, separator: Constants.addressSeparator)
                self.lblAddress.text?.append(object.address?.zip, separator: Constants.addressSeparator)
            }
        }
    }

}
