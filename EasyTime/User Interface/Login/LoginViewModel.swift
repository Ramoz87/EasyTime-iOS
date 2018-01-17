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
        
        AppManager.sharedInstance.dataHelper.fetchData(entityName: User.entityName, predicate: nil) { (result: Array<User>?, error) in
            
            if let user = result?.first{
                AppManager.sharedInstance.login(with: ETUser(user:user))
            }
            else
            {
                AppManager.sharedInstance.logout()
            }
            
            completion((AppManager.sharedInstance.user != nil) , error)
        }
    }
}
