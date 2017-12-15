//
//  ETAddress.swift
//  EasyTime
//
//  Created by Mobexs on 12/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ETAddress {

    var addressId: String?
    var city: String?
    var country: String?
    var street: String?
    var zip: String?

    init(address: Address) {

        self.addressId = address.addressId
        self.city = address.city
        self.country = address.country
        self.street = address.street
        self.zip = address.zip
    }
}
