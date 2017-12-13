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

typealias CompletionBlock = (Array<Any>?, Error?) -> Swift.Void

class DataHelper: NSObject {
    
    static let sharedInstance = DataHelper()
    
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
    func fetchedResultsController<ResultType>(entityName: String, sort: [String]) -> NSFetchedResultsController<ResultType> {

        return self.fetchedResultsController(request: self.fetchRequest(entityName: entityName, sort: sort))
    }
    
    func fetchedResultsController<ResultType>(entityName: String, sort: [String], predicate: NSPredicate) -> NSFetchedResultsController<ResultType> {

        return self.fetchedResultsController(request: self.fetchRequest(entityName: entityName, sort: sort, predicate: predicate))
    }

    func fetchData<ResultType: NSFetchRequestResult>(entityName: String, predicate: NSPredicate?, completion: (Array<ResultType>?, Error?) -> Void)
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
    
    // MARK: - Save data
    func save(completion: @escaping CompletionBlock)  {

        let context = self.mainContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil, nil)
            } catch {
                completion(nil, DataError.contextSaveError(error))
            }
        }
    }
    
    func saveInBackground(data: Array<DataObject>, completion: @escaping CompletionBlock ) {

        let context = self.backgroundContext;
        context.perform {
            for item in data {
                let dataObject = NSEntityDescription.insertNewObject(forEntityName: item.entityName, into: context)
                dataObject.update(object: item)
            }
            do {
                try context.save()
                
                DispatchQueue.main.async(execute: {() -> () in
                    completion(nil, nil)
                })
            } catch {
                DispatchQueue.main.async(execute: {() -> () in
                    completion(nil, DataError.contextSaveError(error))
                })
            }
        }
    }
    
    // MARK: - Delete data
    func delete(data: Array<NSManagedObject>, completion: @escaping CompletionBlock) {

        let context = self.mainContext
        for item in data {
            context.delete(item);
        }
        do {
            try context.save()
            completion(nil, nil)
        } catch {
            completion(nil, DataError.contextSaveError(error))
        }
    }
    
    // MARK: - Private
    private func fetchRequest<ResultType>(entityName: String) -> NSFetchRequest<ResultType> {

        return NSFetchRequest<ResultType>(entityName: entityName)
    }
    
    private func fetchRequest<ResultType>(entityName: String, sort: [String]) -> NSFetchRequest<ResultType> {

        let request: NSFetchRequest<ResultType> = self.fetchRequest(entityName: entityName)
        request.sortDescriptors = sort.map({ (key) -> NSSortDescriptor in
            NSSortDescriptor(key: key, ascending: true)
        })
        return request
    }
    
    private func fetchRequest<ResultType>(entityName: String, sort: [String], predicate: NSPredicate) -> NSFetchRequest<ResultType> {

        let request: NSFetchRequest<ResultType> = self.fetchRequest(entityName: entityName, sort: sort);
        request.predicate = predicate
        return request
    }
    
    private func fetchedResultsController<ResultType>(request: NSFetchRequest<ResultType>) -> NSFetchedResultsController<ResultType> {

        return NSFetchedResultsController<ResultType>(fetchRequest: request, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }
}

protocol DataObject {
    
    var entityName: String { get }
}

extension NSManagedObject {

    func update(object: DataObject) {
        
    }
}
