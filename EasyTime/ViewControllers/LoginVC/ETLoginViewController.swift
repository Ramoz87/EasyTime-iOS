//
//  ETLoginViewController.swift
//  EasyTime
//
//  Created by Mobexs on 12/7/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ETLoginViewController: ETBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var vUsername: UIView!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!

    let viewModel = ETLoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let radius: CGFloat = 4
        self.vUsername.layer.cornerRadius = radius
        self.vPassword.layer.cornerRadius = radius
        self.btnLogin.layer.cornerRadius = radius

        let color = UIColor(red: 109 / 255, green: 137 / 255, blue: 175 / 255, alpha: 0.4).cgColor
        self.vUsername.layer.borderColor = color
        self.vPassword.layer.borderColor = color

        let width: CGFloat = 1
        self.vUsername.layer.borderWidth = width
        self.vPassword.layer.borderWidth = width

        self.tfUsername.placeholder = NSLocalizedString("Username", comment: "")
        self.tfPassword.placeholder = NSLocalizedString("Password", comment: "")
        self.btnLogin.setTitle(NSLocalizedString("LOG IN", comment: ""), for: .normal)
    }

    //MARK:- Action handlers

    @IBAction func login(sender: Any) {

        self.viewModel.login { success, error in
            
        }
    }

    //MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == self.tfUsername {

            self.tfPassword.becomeFirstResponder()
        }
        else if textField == self.tfPassword {

            self.login(sender: self.btnLogin)
        }

        return true
    }
}
