//
//  StatisticTimeCollectionViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 29/03/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class StatisticTimeCollectionViewCell: StatisticCollectionViewCell {

    static let reuseIdentifier = "StatisticTimeCollectionViewCellReuseIdentifier"
    static let cellName = "StatisticTimeCollectionViewCell"
    static let height = 74
    
    @IBOutlet weak var lbStatTime: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progress.transform = progress.transform.scaledBy(x: 1, y: 8)
    }

}
