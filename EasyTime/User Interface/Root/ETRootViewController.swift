//
//  ETRootViewController.swift
//  EasyTime
//
//  Created by Mobexs on 12/7/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ETRootViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.isNavigationBarHidden = true

        AppManager.sharedInstance.authenticator.stateUpdateHandler = { state in

            self.authenticatorStateDidChange(state);
        }
        self.authenticatorStateDidChange(AppManager.sharedInstance.authenticator.state);
    }

    // MARK: - Logic

    func authenticatorStateDidChange(_ state: AuthenticatorState) {

        var newViewController: UIViewController?

        switch state {

        case .Unauthorized:
            newViewController = ETLoginViewController()
        case .Authorized:
            newViewController = ETTabBarViewController()
        }

        self.setViewControllers([newViewController!], animated: true)
    }
}
