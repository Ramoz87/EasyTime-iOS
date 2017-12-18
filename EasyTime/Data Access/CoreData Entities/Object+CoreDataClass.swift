//
//  Object+CoreDataClass.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


public class Object: Job {
    override class var entityName: String  { return "Object" }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        self.entityType = Object.entityName
    }
}
