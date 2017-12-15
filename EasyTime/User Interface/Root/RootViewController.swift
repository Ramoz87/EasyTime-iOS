//
//  RootViewController.swift
//  EasyTime
//
//  Created by Mobexs on 12/7/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class RootViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isNavigationBarHidden = true
        
        if AppManager.sharedInstance.lastSyncDate == nil {
            AppManager.sharedInstance.prepareInitialData { success, error in
                if(success) {
                    AppManager.sharedInstance.lastSyncDate = Date()
                }
            }
        }
        
        AppManager.sharedInstance.authenticator.stateUpdateHandler = { state in
            
            self.authenticatorStateDidChange(state);
        }
        self.authenticatorStateDidChange(AppManager.sharedInstance.authenticator.state);
    }
    
    // MARK: - Logic
    
    func authenticatorStateDidChange(_ state: AuthenticatorState) {
        
        var newViewController: UIViewController?
        var animated: Bool
        
        switch state {
        case .Unauthorized:
            newViewController = LoginViewController()
            animated = false
        case .Authorized:
            newViewController = TabBarViewController()
            animated = true
        }
        
        self.setViewControllers([newViewController!], animated: animated)
    }
}
