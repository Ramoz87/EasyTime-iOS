//
//  InvoiceSectionHeaderView.swift
//  EasyTime
//
//  Created by Mobexs on 1/26/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class InvoiceSectionHeaderView: UIView {

    @IBOutlet weak var lblTitle: UILabel!

    static func createFromXIB() -> InvoiceSectionHeaderView {

        return Bundle.main.loadNibNamed("InvoiceSectionHeaderView", owner: nil, options: nil)!.first as! InvoiceSectionHeaderView
    }

}
