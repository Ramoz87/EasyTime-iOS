//
//  ObjectTableViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 18/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ObjectTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ObjectTableViewCellReuseIdentifier"
    static let cellName = "ObjectTableViewCell"
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    
    var object: ETObject? {
        
        didSet {
            
            if let object = object {
                
                self.lblID.text = object.jobId
                self.lblName.text = object.name
            }
        }
    }

}
