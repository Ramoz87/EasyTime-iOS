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
    static let sectionName = "name"
    static let basePredicate = "job.jobId IN %@"
    
    static let timePredicate = "type = 0"
    static let materialPredicate = "type = 1"
    static let expensePredicate = "type = 2 || type = 3"
    
    static let timeSection = NSLocalizedString("Time", comment: "")
    static let materialSection = NSLocalizedString("Material", comment: "")
    static let expenseSection = NSLocalizedString("Expense", comment: "")
}

class InvoiceViewModel: BaseViewModel {

    let job: ETJob
    var sections = [NSFetchedResultsController<Expense>]()
    
    private var basePredicate: NSPredicate {
        get {
            var arrayOfJobId: [String] = []
            
            if let jobId = self.job.jobId {
                arrayOfJobId.append(jobId)
            }
            
            if let objects = self.job.objects, objects.count > 0 {
                arrayOfJobId.append(contentsOf: objects)
            }
            
            return NSPredicate(format: Constants.basePredicate, arrayOfJobId)
        }
    }
    
    private func predicate(for type: ETExpenseType) -> NSPredicate {
        var predicate: NSPredicate
        switch type {
        case .time:
            predicate = NSPredicate(format: Constants.timePredicate)
            break
        case .material:
            predicate = NSPredicate(format: Constants.materialPredicate)
            break
        default:
            predicate = NSPredicate(format: Constants.expensePredicate)
            break
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self.basePredicate, predicate])
    }
    
    private lazy var fetchResultsControllerTime: NSFetchedResultsController<Expense> = {

        let fetchedResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                          predicate: self.predicate(for: .time),
                                                                                                                                      sectionNameKeyPath: Constants.sectionName)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private lazy var fetchResultsControllerMaterial: NSFetchedResultsController<Expense> = {
        
        let fetchedResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                          predicate: self.predicate(for: .material),
                                                                                                                                          sectionNameKeyPath: Constants.sectionName)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private lazy var fetchResultsControllerExpense: NSFetchedResultsController<Expense> = {
        
        let fetchedResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                          predicate: self.predicate(for: .other),
                                                                                                                                          sectionNameKeyPath: Constants.sectionName)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    init(job: ETJob) {

        self.job = job
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(indexPath: IndexPath) -> ETExpense {

        let fetchedResultsController = self.sections[indexPath.section]
        guard let sectionInfo = fetchedResultsController.sections?[indexPath.row] else {
            return ETExpense()
        }
        
        return ETExpense(expenses: sectionInfo.objects as? [Expense])
    }

    func numberOfSections() -> Int {
        
        return self.sections.count
    }

    func numberOfRowsInSection(section: Int) -> Int {
        
        guard let count = self.sections[section].sections?.count else { return 0 }
        return count
    }

    func titleForHeaderInSection(section: Int) -> String? {
        let fetchedResultsController = self.sections[section]
        
        if  fetchedResultsController==self.fetchResultsControllerTime {
            return Constants.timeSection
        }
        
        if  fetchedResultsController==self.fetchResultsControllerMaterial {
            return Constants.materialSection
        }
        
        if  fetchedResultsController==self.fetchResultsControllerExpense {
            return Constants.expenseSection
        }
        
        return nil
    }

    func titleForFooterInSection(section: Int) -> String? {

//        guard let expenses = self.fetchResultsController.sections?[section].objects else { return nil }
//        guard let sum = (expenses as NSArray).value(forKeyPath: "@sum.value") as? NSNumber else { return nil }
        return "\(0)"
    }

    func updateResult() {
        
        sections.removeAll()
        
        do {
            try self.fetchResultsControllerTime.performFetch()
            try self.fetchResultsControllerMaterial.performFetch()
            try self.fetchResultsControllerExpense.performFetch()
            
            if let count = self.fetchResultsControllerTime.sections?.count, count>0 {
                sections.append(self.fetchResultsControllerTime)
            }
            
            if let count = self.fetchResultsControllerMaterial.sections?.count, count>0 {
                sections.append(self.fetchResultsControllerMaterial)
            }
            
            if let count = self.fetchResultsControllerExpense.sections?.count, count>0 {
                sections.append(self.fetchResultsControllerExpense)
            }
            
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }

    func updateSignature(image: UIImage?, author: SignatureAuthorType) {

        //TODO: Save signature
    }
}
