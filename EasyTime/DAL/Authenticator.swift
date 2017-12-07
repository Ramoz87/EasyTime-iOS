//
//  Authenticator.swift
//  EasyTime
//
//  Created by Mobexs on 12/7/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

@objc enum AuthenticatorState: Int {

    case Unauthorized
    case Authorized
}

class Authenticator: NSObject {

    @objc dynamic var state: AuthenticatorState = .Unauthorized
}
