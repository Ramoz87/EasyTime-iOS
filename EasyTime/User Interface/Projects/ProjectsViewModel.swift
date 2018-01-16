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
    static let searchPredicate1 = "date < %@"
    static let searchPredicate2 = "name CONTAINS[cd] %@"
}

class ProjectsViewModel: BaseViewModel {

    private lazy var fetchResultsController: NSFetchedResultsController<Job> = {
        
        let fetchedResultsController: NSFetchedResultsController<Job> = AppManager.sharedInstance.dataHelper.fetchedResultsController(entityName: Job.entityName,
                                                                                                                                     sort: [Constants.sectionName,Constants.sortDescriptor],
                                                                                                                                     sectionNameKeyPath:Constants.sectionName)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    required init() {
        super.init()
        
        self.updateSearchResults(date: Date(), text: nil)
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

    func updateSearchResults(date: Date, text: String?) {

        var predicate = NSPredicate(format: Constants.searchPredicate1, date as NSDate)
        if let text = text, text.count > 0 {

            predicate = NSPredicate(format: Constants.searchPredicate1 + " && " + Constants.searchPredicate2, date as NSDate, text)
        }

        self.fetchResultsController.fetchRequest.predicate = predicate
        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
}
