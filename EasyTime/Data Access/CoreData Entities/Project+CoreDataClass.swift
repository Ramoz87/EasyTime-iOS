//
//  Project+CoreDataClass.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData

fileprivate struct Constants
{
    static let customerPredicate = "customerId = %@"
}

public class Project: Job {
    
    var customer: Customer? {

        get {

            guard let customerId = self.customerId else { return nil }
            let request = NSFetchRequest<Customer>(entityName: Customer.entityName)
            request.predicate = NSPredicate(format: Constants.customerPredicate, customerId)
            do {
                return try self.managedObjectContext?.fetch(request).first
            }
            catch {

                return nil
            }
        }
    }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        self.entityType = Project.entityName
    }
    
    override func update(object: Any) {
        super.update(object: object)
        
        if let csvObject = object as? CSVObject {
            
            self.dateEnd = NSDate()
            self.dateStart = NSDate()
            self.objects = csvObject[13]
        }
    }
}
