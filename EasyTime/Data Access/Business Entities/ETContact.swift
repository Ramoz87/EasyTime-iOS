//
//  ETContact.swift
//  EasyTime
//
//  Created by Mobexs on 1/30/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ETContact {

    var contactId: String?
    var email: String?
    var fax: String?
    var firstName: String?
    var lastName: String?
    var phone: String?

    private let contact: Contact

    init(contact: Contact) {

        self.contact = contact
        self.contactId = contact.contactId
        self.email = contact.email
        self.fax = contact.fax
        self.firstName = contact.firstName
        self.lastName = contact.lastName
        self.phone = contact.phone
    }
}
