//
//  ETMaterial.swift
//  EasyTime
//
//  Created by Mobexs on 1/19/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ETMaterial {

    var currency: String?
    var materialId: String?
    var materialNr: String?
    var pricePerUnit: Float
    var serailNr: String?
    var stockQuantity: Float
    var unitId: String?
    var name: String?
    private let material: Material

    init(material: Material) {

        self.material = material
        self.currency = material.currency
        self.materialId = material.materialId
        self.materialNr = material.materialNr
        self.pricePerUnit = material.pricePerUnit
        self.serailNr = material.serailNr
        self.stockQuantity = material.stockQuantity
        self.unitId = material.unitId
        self.name = material.name
    }
}
