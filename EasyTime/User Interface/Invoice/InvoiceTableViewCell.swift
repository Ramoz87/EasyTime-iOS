//
//  InvoiceTableViewCell.swift
//  EasyTime
//
//  Created by Mobexs on 1/25/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class InvoiceTableViewCell: UITableViewCell {

    static let reuseIdentifier = "InvoiceTableViewCellReuseIdentifier"
    static let cellName = "InvoiceTableViewCell"

    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblDetails: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
