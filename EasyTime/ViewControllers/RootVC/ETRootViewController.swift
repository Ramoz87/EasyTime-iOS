//
//  ETRootViewController.swift
//  EasyTime
//
//  Created by Mobexs on 12/7/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ETRootViewController: ETBaseViewController {

    var viewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        DataHelper.sharedInstance.authenticator.addObserver(self, forKeyPath: "state", options: .new, context: nil)
        self.authenticatorStateDidChange();
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        if let viewController = self.viewController {

            viewController.view.frame = self.view.bounds
        }
    }

    //MARK: - KVO

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        self.authenticatorStateDidChange()
    }

    // MARK: - Logic

    func authenticatorStateDidChange() {

        let state = DataHelper.sharedInstance.authenticator.state
        var newViewController: UIViewController?

        switch state {

        case .Unauthorized:
            let navigationController = UINavigationController(rootViewController: ETLoginViewController())
            navigationController.isNavigationBarHidden = true
            newViewController = navigationController
        case .Authorized:
            newViewController = ETTabBarViewController()
        }

        if let viewController = self.viewController {

            viewController.willMove(toParentViewController: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
        }

        self.viewController = newViewController;

        if let viewController = self.viewController {

            self.addChildViewController(viewController)
            self.view.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
        }
    }

    //MARK: - Clean

    deinit {

        DataHelper.sharedInstance.authenticator.removeObserver(self, forKeyPath: "state")
    }
}
