//
//  DataHelper.swift
//  easyService
//
//  Created by Yury Ramazanov on 28/04/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants
{
    static let modelName = "EasyTime"
}

enum DataError : Error {
    case contextSaveError(Error)
    case contextFetchError(Error)
}

typealias CompletionBlock<Type> = (Array<Type>?, Error?) -> Swift.Void
typealias ErrorBlock = (Error?) -> Swift.Void

class DataHelper: NSObject {
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: Constants.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in})
        return container
    }()
    
    private lazy var mainContext: NSManagedObjectContext = {

        return self.persistentContainer.viewContext
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {

        return self.persistentContainer.newBackgroundContext()
    }()
    
    // MARK: - Fetch data

    func fetchedResultsController<ResultType>(entityName: String, sort: [String]? = nil, predicate: NSPredicate? = nil, sectionNameKeyPath: String? = nil) -> NSFetchedResultsController<ResultType> {

        let request: NSFetchRequest<ResultType> = self.fetchRequest(entityName: entityName, sort: sort, predicate: predicate)

        return NSFetchedResultsController<ResultType>(fetchRequest: request,
                                                      managedObjectContext: self.mainContext,
                                                      sectionNameKeyPath: sectionNameKeyPath,
                                                      cacheName: nil)
    }

    func fetchData<ResultType: NSFetchRequestResult>(entityName: String, predicate: NSPredicate?) throws -> Array<ResultType>?
    {
        let request: NSFetchRequest<ResultType> = self.fetchRequest(entityName: entityName)
        if let pred = predicate { request.predicate = pred }
        return try self.mainContext.fetch(request)
    }
    
    func fetchData<ResultType: NSFetchRequestResult>(entityName: String, predicate: NSPredicate?, completion: CompletionBlock<ResultType>) -> Void
    {
        let request: NSFetchRequest<ResultType> = self.fetchRequest(entityName: entityName)
        if let pred = predicate { request.predicate = pred }
        
        do {
            let fetchedData = try self.mainContext.fetch(request)
            completion(fetchedData, nil)
        } catch {
            completion(nil, DataError.contextFetchError(error))
        }
    }
    
    func insertEntity<ResultType: NSManagedObject>(entityName: String) -> ResultType {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.mainContext) as! ResultType
    }
    
    // MARK: - Save data
    func save(completion: @escaping ErrorBlock)  {

        let context = self.mainContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(DataError.contextSaveError(error))
            }
        }
    }
    
    func saveInBackground(data: Array<DataObject>, completion: @escaping CompletionBlock<NSManagedObject> ) {

        let context = self.backgroundContext;
        context.perform {
            var createdObjects = [NSManagedObject]()
            
            for item in data {
                let dataObject = NSEntityDescription.insertNewObject(forEntityName: item.entityName, into: context)
                if let updateDataObject = dataObject as? NSManagedObjectUpdate {
                    updateDataObject.update(object: item)
                }
                createdObjects.append(dataObject)
            }
            
            if context.hasChanges {
                do {
                    try context.save()
                    DispatchQueue.main.async(execute: {() -> () in
                        completion(createdObjects, nil)
                    })
                } catch {
                    DispatchQueue.main.async(execute: {() -> () in
                        completion(nil, DataError.contextSaveError(error))
                    })
                }
            }
            else {
                DispatchQueue.main.async(execute: {() -> () in
                    completion(createdObjects, nil)
                })
            }
        }
    }
    
    // MARK: - Delete data
    func delete(data: Array<NSManagedObject>, completion: @escaping ErrorBlock) {

        let context = self.mainContext
        for item in data {
            context.delete(item);
        }
        do {
            try context.save()
            completion(nil)
        } catch {
            completion(DataError.contextSaveError(error))
        }
    }
    
    // MARK: - Private

    private func fetchRequest<ResultType>(entityName: String, sort: [String]? = nil, predicate: NSPredicate? = nil) -> NSFetchRequest<ResultType> {

        let request = NSFetchRequest<ResultType>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sort?.map({ (key) -> NSSortDescriptor in

            NSSortDescriptor(key: key, ascending: true)
        })
        return request
    }
}

protocol DataObject {

    var entityName: String { get }
}

protocol NSManagedObjectUpdate {
    func update(object: DataObject)
}
