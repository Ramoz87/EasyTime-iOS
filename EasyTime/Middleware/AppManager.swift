//
//  AppManager.swift
//  EasyTime
//
//  Created by Mobexs on 12/8/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class AppManager {

    static let sharedInstance = AppManager()
    let authenticator = Authenticator()
    let dataHelper = DataHelper()
}
