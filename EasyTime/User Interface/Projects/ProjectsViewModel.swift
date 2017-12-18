//
//  ProjectsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 12/12/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {
    static let sortDescriptor = "name"
    static let sectionName = "entityType"
    static let searchPredicate = "name CONTAINS[cd] %@"
}

class ProjectsViewModel: BaseViewModel {

    
    private lazy var fetchResultsController: NSFetchedResultsController<Job> = {
        
        let fetchedResultsController: NSFetchedResultsController<Job> = AppManager.sharedInstance.dataHelper.fetchedResultsController(entityName: Job.entityName,
                                                                                                                                     sort: [Constants.sortDescriptor],
                                                                                                                                     sectionNameKeyPath:Constants.sectionName)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    required init() {

        /*
        let context = AppManager.sharedInstance.dataHelper.mainContext
        for i in 1...10 {

            let job = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! Project
            job.jobId = "Project \(i)"
            job.name = "Project \(i)"
        }
        for i in 1...10 {

            let job = NSEntityDescription.insertNewObject(forEntityName: "Object", into: context) as! Object
            job.jobId = "Object \(i)"
            job.name = "Object \(i)"
        }
        for i in 1...10 {

            let job = NSEntityDescription.insertNewObject(forEntityName: "Order", into: context) as! Order
            job.jobId = "Order \(i)"
            job.name = "Order \(i)"
        }
        do { try context.save() } catch (let error){ print(error) } //TODO: REMOVE
 */

        super.init()
        
        do {
            try self.fetchResultsController.performFetch()
        } catch {}
    }

    subscript(indexPath: IndexPath) -> ETJob {

        let job = self.fetchResultsController.object(at: indexPath)

        if let project = job as? Project {

            return ETProject(project: project)
        }
        else if let object = job as? Object {

            return ETObject(object: object)
        }
        else if let order = job as? Order {

            return ETOrder(order: order)
        }

        return ETJob(job: job)
    }

    func numberOfSections() -> Int {

        guard let count = self.fetchResultsController.sections?.count else { return 0 }
        return count
    }

    func numberOfRowsInSection(section: Int) -> Int {

        guard let count = self.fetchResultsController.sections?[section].numberOfObjects else { return 0 }
        return count
    }

    func titleForHeaderInSection(section: Int) -> String? {

        guard let sections = self.fetchResultsController.sections, section < sections.count else { return "" }
        return sections[section].name
    }

    func updateSearchResults(text: String?) {

        var predicate: NSPredicate?
        if let text = text, text.count > 0 {

            predicate = NSPredicate(format: Constants.searchPredicate, text)
        }
        
        self.fetchResultsController.fetchRequest.predicate = predicate
        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
}
