//
//  AddExpenseViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let titleText = NSLocalizedString("Expenses", comment: "")
    static let buttonCornerRadius: CGFloat = 4
    static let buttonBorderColor = UIColor(red: 109 / 255, green: 137 / 255, blue: 175 / 255, alpha: 1)
    static let buttonBorderDashPattern: [NSNumber] = [4, 4]
    static let buttonIconSpacing: CGFloat = 7
}

class AddExpenseViewController: BaseViewController<AddExpenseViewModel> {

    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var lblExpenseType: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var btnAdd: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.titleText

        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = Constants.buttonBorderColor.cgColor
        borderLayer.lineDashPattern = Constants.buttonBorderDashPattern
        borderLayer.frame = self.btnAdd.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(rect: self.btnAdd.bounds).cgPath
        self.btnAdd.layer.addSublayer(borderLayer)
        self.btnAdd.layer.cornerRadius = Constants.buttonCornerRadius
        self.btnAdd.alignVertical(spacing: Constants.buttonIconSpacing)

        let controller = NumberInputViewController()
        self.tfValue.inputViewController = controller

        self.lblExpenseType.text = self.viewModel.name
    }

    //MARK: - Action handlers

    @IBAction func didTapAddButton(sender: Any) {

    }
}
