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
}

class AddExpenseViewController: BaseViewController<AddExpenseViewModel> {

    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var lblExpenseType: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var btnAdd: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.titleText
        self.btnAdd.alignVertical()

        let controller = NumberInputViewController()
        self.tfValue.inputViewController = controller
    }

    //MARK: - Action handlers

    @IBAction func didTapAddButton(sender: Any) {

    }
}
