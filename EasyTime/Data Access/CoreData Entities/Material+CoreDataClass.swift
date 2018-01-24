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


public class Material: NSManagedObject, DataHelperProtocol {
    
    @objc dynamic var section: String {
        guard let name = self.name, name.count > 0 else {
            return "#"
        }
        
        return String(describing:name.first!)
    }
    
    func update(object: Any) {
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
