//
//  SettingsViewController.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 07/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController<SettingsViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - Action handlers

    @IBAction func logout(sender: Any) {

        AppManager.sharedInstance.authenticator.state = .Unauthorized
    }
}
