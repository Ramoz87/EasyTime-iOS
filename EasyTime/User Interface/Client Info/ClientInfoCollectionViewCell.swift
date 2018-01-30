//
//  ClientInfoCollectionViewCell.swift
//  EasyTime
//
//  Created by Mobexs on 1/30/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

protocol ClientInfoCollectionViewCellDelegate: class {

    func clientInfoCollectionViewCellDidTapSendEmail(cell: ClientInfoCollectionViewCell)
    func clientInfoCollectionViewCellDidTapOpenMap(cell: ClientInfoCollectionViewCell)
    func clientInfoCollectionViewCellDidTapCallPhone(cell: ClientInfoCollectionViewCell)
}

class ClientInfoCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ClientInfoCollectionViewCellReuseIdentifier"
    static let cellName = "ClientInfoCollectionViewCell"

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnSendEmail: UIButton!
    @IBOutlet weak var btnOpenMap: UIButton!
    @IBOutlet weak var btnCallPhone: UIButton!

    weak var delegate: ClientInfoCollectionViewCellDelegate?
    var contact: ETContact?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: - Action handlers

    @IBAction func didTapSendEmailButton(sender: Any) {

        self.delegate?.clientInfoCollectionViewCellDidTapSendEmail(cell: self)
    }

    @IBAction func didTapOpenMapButton(sender: Any) {

        self.delegate?.clientInfoCollectionViewCellDidTapOpenMap(cell: self)
    }

    @IBAction func didTapCallPhonelButton(sender: Any) {

        self.delegate?.clientInfoCollectionViewCellDidTapCallPhone(cell: self)
    }
}
