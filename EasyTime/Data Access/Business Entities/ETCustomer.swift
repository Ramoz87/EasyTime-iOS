//
//  ETCustomer.swift
//  EasyTime
//
//  Created by Mobexs on 12/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ETCustomer {

    var companyName: String?
    var customerId: String?
    var firstName: String?
    var lastName: String?
    var contacts: NSSet?
    var jobStatistic: String?

    lazy var address: ETAddress? = {

        if let address = self.customer.address {

            return ETAddress(address: address)
        }
        return nil
    }()
    
    private let customer: Customer

    init(customer: Customer) {

        self.customer = customer
        self.companyName = customer.companyName
        self.customerId = customer.customerId
        self.firstName = customer.firstName
        self.lastName = customer.lastName
        self.contacts = customer.contacts
    }
}
