//
//  ENLoginViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 12/7/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ETLoginViewModel: ETBaseViewModel {

    func login(completion: @escaping((_ success: Bool, _ error: Error?) -> Void)) {

        AppManager.sharedInstance.authenticator.state = .Authorized
        completion(true , nil)
    }
}
