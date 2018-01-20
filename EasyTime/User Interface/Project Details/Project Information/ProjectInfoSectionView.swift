//
//  ProjectInfoSectionView.swift
//  EasyTime
//
//  Created by Mobexs on 1/20/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ProjectInfoSectionView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgAccessory: UIImageView!
    @IBOutlet weak var button: UIButton!

    static func createFromXIB() -> ProjectInfoSectionView {

        return Bundle.main.loadNibNamed("ProjectInfoSectionView", owner: nil, options: nil)!.first as! ProjectInfoSectionView
    }
}
