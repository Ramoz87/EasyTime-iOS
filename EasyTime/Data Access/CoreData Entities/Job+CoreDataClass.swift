//
//  Job+CoreDataClass.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


public class Job: NSManagedObject, DataHelperProtocol {
    
    func update(object: Any) {
        if let csvObject = object as? CSVObject {
        
            self.currency = csvObject[10]
            self.customerId = csvObject[2]
            self.date = NSDate()
            self.information = csvObject[7]
            self.jobId = csvObject[1]
            self.members = csvObject[8]
            self.name = csvObject[6]
            self.number = csvObject[5]
            self.statusId = csvObject[3]
            self.typeId = csvObject[4]
        }
    }
}
