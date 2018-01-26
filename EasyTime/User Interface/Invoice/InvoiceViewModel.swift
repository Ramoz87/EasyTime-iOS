//
//  InvoiceViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/25/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {
    
    static let sortDescriptor = "name"
    static let sectionName = "type"
}

class InvoiceViewModel: BaseViewModel {

    let job: ETJob
    lazy var customer: ETCustomer? = {

        do {

            guard let customerId = self.job.customerId else { return nil }
            let predicate = NSPredicate(format: "customerId = %@", customerId)
            guard let customer: Customer = try AppManager.sharedInstance.dataHelper.fetchData(predicate: predicate)?.first else { return nil }
            return ETCustomer(customer: customer)
        }
        catch { return nil }
    }()
    private lazy var fetchResultsController: NSFetchedResultsController<Expense> = {

        let fetchedResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sectionName, Constants.sortDescriptor],
                                                                                                                                      sectionNameKeyPath: Constants.sectionName)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    init(job: ETJob) {

        self.job = job
        super.init()
        self.fetchData()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(indexPath: IndexPath) -> ETExpense {

        let expense = self.fetchResultsController.object(at: indexPath)
        return ETExpense(expense: expense)
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

    func titleForFooterInSection(section: Int) -> String? {

        guard let expenses = self.fetchResultsController.sections?[section].objects else { return nil }
        guard let sum = (expenses as NSArray).value(forKeyPath: "@sum.value") as? NSNumber else { return nil }
        return "\(sum)"
    }

    func fetchData() {

        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }

    func updateSignature(image: UIImage?, author: SignatureAuthorType) {

        //TODO: Save signature
    }
}
