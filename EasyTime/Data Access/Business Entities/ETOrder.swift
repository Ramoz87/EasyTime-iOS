//
//  ETOrder.swift
//  EasyTime
//
//  Created by Mobexs on 12/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ETOrder: ETJob {

    var contact: String?
    var deliveryTime: String?
    var objects: String?
    lazy var deliveryAddress: ETAddress? = {

        if let address = self.order.deliveryAddress {

            return ETAddress(address: address)
        }
        return nil
    }()

    private let order: Order

    init(order: Order) {

        self.order = order
        super.init(job: order)

        self.contact = order.contact
        self.deliveryTime = order.deliveryTime
        self.objects = order.objects
    }
}