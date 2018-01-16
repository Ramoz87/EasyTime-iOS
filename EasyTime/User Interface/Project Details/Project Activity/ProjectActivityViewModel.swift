//
//  ProjectActivityViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {

    static let sortDescriptor = "date"
    static let searchPredicate = "date > %@ && date < %@"
}

class ProjectActivityViewModel: BaseViewModel {

    private let job: ETJob
    private lazy var fetchResultsController: NSFetchedResultsController<Expense> = {

        let fetchedResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(entityName: Expense.entityName,
                                                                                                                                      sort: [Constants.sortDescriptor],
                                                                                                                                      sectionNameKeyPath:nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    init(job: ETJob) {

        self.job = job
        super.init()
        self.updateFilterResults()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(indexPath: IndexPath) -> ETExpense {

        let expense = self.fetchResultsController.object(at: indexPath)
        return ETExpense(expense: expense)
    }

    func numberOfRowsInSection(section: Int) -> Int {

        guard let count = self.fetchResultsController.sections?[section].numberOfObjects else { return 0 }
        return count
    }

    func updateFilterResults(date: Date = Date()) {

        let predicate: NSPredicate = NSPredicate(format: Constants.searchPredicate, date as NSDate, date as NSDate) // TODO: start and end date

        self.fetchResultsController.fetchRequest.predicate = predicate
        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }

    func nextViewController(expenseType: ETExpenseType) -> UIViewController {

        if let project = self.job as? ETProject,
            let objects = project.objects,
            objects.count > 0 {

            let viewModel = ObjectsViewModel(project: project, expenseType: expenseType)
            return ObjectsViewController(viewModel: viewModel)
        }

        switch expenseType {

            case .time:
                let viewModel = WorkTypeViewModel(job: self.job)
                return WorkTypeViewController(viewModel: viewModel)
            case .money:
                let viewModel = ExpenseTypeViewModel(job: self.job)
                return ExpenseTypeViewController(viewModel: viewModel)
            case .material:
                return UIViewController() // TODO: Impement
        }

    }
}
