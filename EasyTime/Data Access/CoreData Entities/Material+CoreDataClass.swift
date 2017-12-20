//
//  Material+CoreDataClass.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


public class Material: NSManagedObject, NSManagedObjectUpdate {
    static let entityName = "Material"
    
    func update(object: DataObject) {
        if let csvObject = object as? CSVObject {
            
            self.materialId = csvObject[0]
            self.currency = csvObject[1]
            self.materialNr = csvObject[2]
            self.name = csvObject[3]
            if let priceStr = csvObject[4] {
                self.pricePerUnit = Float(priceStr)!
            }
            self.serailNr = csvObject[5]
            self.unitId = csvObject[6]
        }
    }
}
