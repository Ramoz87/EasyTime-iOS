//
//  ExpenseTypeViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {

    static let sortDescriptor = "name"
    static let searchPredicateBaseExpense = "type = 'EXPENCE_TYPE'"
    static let searchPredicateBaseHistory = "type = 2 OR type = 3"
    static let searchPredicate2 = "name CONTAINS[cd] %@"
    static let sectionNumber = 2
}

class ExpenseTypeViewModel: BaseViewModel {

    private(set) var job: ETJob
  
    private lazy var expenseTypeFetchResultsController: NSFetchedResultsController<Type> = {
        
        let fetchResultsController: NSFetchedResultsController<Type> = AppManager.sharedInstance.dataHelper.fetchedResultsController(entityName: Type.entityName,
                                                                                                                                                sort: [Constants.sortDescriptor],
                                                                                                                                                sectionNameKeyPath:nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()
    
    private lazy var expenseHistoryFetchResultsController: NSFetchedResultsController<Expense> = {
        
        let fetchResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(entityName: Expense.entityName,
                                                                                                                                                   sort: [Constants.sortDescriptor],
                                                                                                                                                   sectionNameKeyPath:nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()

    init(job: ETJob) {

        self.job = job
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(indexPath: IndexPath) -> Any {

        if  indexPath.section == 0 {
            let type = self.expenseTypeFetchResultsController.object(at: IndexPath(row: indexPath.row, section: 0))
            return ETType(type: type)
        }
        else
        {
            let expense = self.expenseHistoryFetchResultsController.object(at: IndexPath(row: indexPath.row, section: 0))
            return ETExpense(expense: expense)
        }
    }

    func numberOfSections() -> Int {
        return Constants.sectionNumber
    }

    func numberOfRowsInSection(section: Int) -> Int {

        var numberOfRows = 0
        
        if  section == 0, let count = self.expenseTypeFetchResultsController.sections?[0].numberOfObjects {
            numberOfRows = count
        }
        
        if  section == 1, let count = self.expenseHistoryFetchResultsController.sections?[0].numberOfObjects {
            numberOfRows = count
        }
       
        return numberOfRows
    }

    func updateSearchResults(text: String? = nil) {

        var predicateExpense = NSPredicate(format: Constants.searchPredicateBaseExpense)
        var predicateHistory = NSPredicate(format: Constants.searchPredicateBaseHistory)
        
        if let text = text, text.count > 0 {
            
            let predicate = NSPredicate(format: Constants.searchPredicate2, text)
            predicateExpense = NSCompoundPredicate(type: .and, subpredicates: [predicateExpense, predicate])
            predicateHistory = NSCompoundPredicate(type: .and, subpredicates: [predicateHistory, predicate])
        }

        self.expenseTypeFetchResultsController.fetchRequest.predicate = predicateExpense
        self.expenseHistoryFetchResultsController.fetchRequest.predicate = predicateHistory
        
        do {
            try self.expenseTypeFetchResultsController.performFetch()
            try self.expenseHistoryFetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
}
