//
//  ENLoginViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 12/7/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class LoginViewModel: BaseViewModel {

    func login(completion: @escaping((_ success: Bool, _ error: Error?) -> Void)) {

        let fetchComplete: (Array<User>?, Error?) -> Void = { (result, error) in
            if let user = result?.first {
                AppManager.sharedInstance.authenticator.user = ETUser(user:user)
                AppManager.sharedInstance.authenticator.state = .Authorized
            }
            else
            {
                AppManager.sharedInstance.authenticator.logout()
            }
            
            completion((AppManager.sharedInstance.authenticator.state == .Authorized) , error)
        }
        
        AppManager.sharedInstance.dataHelper.fetchData(entityName: User.entityName, predicate: nil, completion: fetchComplete)
    }
}
