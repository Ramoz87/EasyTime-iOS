//
//  ClientInfoViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/24/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {

    static let sortDescriptor = "name"
    static let filterPredicate = "customerId = %@ && entityType = %@"
    static let tabViewTitles = [
        NSLocalizedString("PROJECTS", comment: ""),
        NSLocalizedString("ORDERS", comment: ""),
        NSLocalizedString("OBJECTS", comment: "")]
}

enum ClientInfoTabType: Int {

    case projects
    case orders
    case objects

    static func count() -> Int {

        return 3
    }

    func title() -> String {

        return Constants.tabViewTitles[self.rawValue]
    }

    func entityType() -> String {

        switch self {
        case .projects:
            return Project.entityName
        case .orders:
            return Order.entityName
        case .objects:
            return Object.entityName
        }
    }
}

class ClientInfoViewModel: BaseViewModel {

    let customer: ETCustomer
    private lazy var fetchResultsController: NSFetchedResultsController<Job> = {

        let fetchedResultsController: NSFetchedResultsController<Job> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                      sectionNameKeyPath: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    init(customer: ETCustomer) {

        self.customer = customer
        super.init()
        self.updateFilterResults()
    }

    required init() {
        fatalError("init() has not been implemented")
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

    //MARK: - TabView

    func numberOfTabs() -> Int {

        return ClientInfoTabType.count()
    }

    func titleForTab(at index: Int) -> String? {

        return ClientInfoTabType(rawValue: index)?.title()
    }

    //MARK: - TableView

    func numberOfSections() -> Int {

        guard let count = self.fetchResultsController.sections?.count else { return 0 }
        return count
    }

    func numberOfRowsInSection(section: Int) -> Int {

        guard let count = self.fetchResultsController.sections?[section].numberOfObjects else { return 0 }
        return count
    }

    func updateFilterResults(type: ClientInfoTabType = .projects) {

        let predicate = NSPredicate(format: Constants.filterPredicate, self.customer.customerId!, type.entityType())
        self.fetchResultsController.fetchRequest.predicate = predicate

        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
}
