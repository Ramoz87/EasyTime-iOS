//
//  ENLoginViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 12/7/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ETLoginViewModel {

    func login(completion: @escaping((_ success: Bool, _ error: Error?) -> Void)) {

        DataHelper.sharedInstance.authenticator.state = .Authorized
        completion(true , nil)
    }
}
