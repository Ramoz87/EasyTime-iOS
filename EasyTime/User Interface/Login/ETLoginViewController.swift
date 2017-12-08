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
    @IBOutlet weak var btnForgotPassword: UIButton!

    let viewModel = ETLoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let radius: CGFloat = 4
        self.vUsername.layer.cornerRadius = radius
        self.vPassword.layer.cornerRadius = radius
        self.btnLogin.layer.cornerRadius = radius

        self.vUsername.layer.borderColor = UIColor.et_borderColor.cgColor
        self.vPassword.layer.borderColor = UIColor.et_borderColor.cgColor
        self.btnLogin.backgroundColor = UIColor.et_blueColor

        let width: CGFloat = 1
        self.vUsername.layer.borderWidth = width
        self.vPassword.layer.borderWidth = width

        self.tfUsername.placeholder = NSLocalizedString("Username", comment: "")
        self.tfPassword.placeholder = NSLocalizedString("Password", comment: "")
        self.btnLogin.setTitle(NSLocalizedString("LOG IN", comment: ""), for: .normal)
        self.btnForgotPassword.setTitle(NSLocalizedString("Forgot password?", comment: ""), for: .normal)
    }

    //MARK:- Action handlers

    @IBAction func login(sender: Any) {

        self.viewModel.login { success, error in
            
        }
    }

    @IBAction func forgotPassord(sender: Any) {

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
