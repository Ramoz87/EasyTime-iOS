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
    static let sectionName = "entityType"
    static let filterPredicate = "customerId = %@"
    static let tabViewTitles = [
        Project.entityName: NSLocalizedString("PROJECTS", comment: ""),
        Order.entityName: NSLocalizedString("ORDERS", comment: ""),
        Object.entityName: NSLocalizedString("OBJECTS", comment: "")]
}

class ClientInfoViewModel: BaseViewModel {

    let customer: ETCustomer
    var selectedTabIndex: Int = 0
    private lazy var fetchResultsController: NSFetchedResultsController<Job> = {

        let fetchedResultsController: NSFetchedResultsController<Job> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                      sectionNameKeyPath: Constants.sectionName)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    init(customer: ETCustomer) {

        self.customer = customer
        super.init()
        self.fetchData()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(indexPath: IndexPath) -> ETJob {

        let updatedIndexPath = IndexPath(row: indexPath.row, section: self.selectedTabIndex)
        let job = self.fetchResultsController.object(at: updatedIndexPath)

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

        guard let count = self.fetchResultsController.sections?.count else { return 0 }
        return count
    }

    func titleForTab(at index: Int) -> String? {

        guard let title = self.fetchResultsController.sections?[index].name else { return "" }
        return Constants.tabViewTitles[title]
    }

    //MARK: - TableView

    func numberOfSections() -> Int {
        
        return self.numberOfTabs() > 0 ? 1 : 0
    }

    func numberOfRowsInSection(section: Int) -> Int {

        guard let count = self.fetchResultsController.sections?[section].numberOfObjects else { return 0 }
        return count
    }

    private func fetchData() {

        let predicate = NSPredicate(format: Constants.filterPredicate, self.customer.customerId!)
        self.fetchResultsController.fetchRequest.predicate = predicate

        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
}
