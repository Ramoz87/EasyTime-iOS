//
//  ObjectsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {

    static let sortDescriptor = "name"
    static let sectionName = "name"
    static let searchPredicate1 = "jobId IN %@"
    static let searchPredicate2 = "name CONTAINS[cd] %@"
}

class ObjectsViewModel: BaseViewModel {

    private let project: ETProject
    private let expenseType: ETExpenseType
    private lazy var fetchResultsController: NSFetchedResultsController<Object> = {

        let fetchedResultsController: NSFetchedResultsController<Object> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                          sectionNameKeyPath:Constants.sectionName)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    init(project: ETProject, expenseType: ETExpenseType) {

        self.project = project
        self.expenseType = expenseType
        super.init()
        self.updateSearchResults()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(indexPath: IndexPath) -> ETObject {

        let object = self.fetchResultsController.object(at: indexPath)
        return ETObject(object: object)
    }

    func numberOfSections() -> Int {

        guard let count = self.fetchResultsController.sections?.count else { return 0 }
        return count
    }

    func numberOfRowsInSection(section: Int) -> Int {

        guard let count = self.fetchResultsController.sections?[section].numberOfObjects else { return 0 }
        return count
    }

    func sectionForSectionIndexTitle(_ title: String, at index: Int) -> Int {

        return self.fetchResultsController.section(forSectionIndexTitle: title, at: index)
    }

    func sectionIndexTitles() -> [String]? {

        return self.fetchResultsController.sectionIndexTitles
    }

    func updateSearchResults(text: String? = nil) {

        guard let objects = self.project.objects?.components(separatedBy: ",") else { return }

        var predicate = NSPredicate(format: Constants.searchPredicate1, objects)
        if let text = text, text.count > 0 {

            predicate = NSPredicate(format: Constants.searchPredicate1 + " && " + Constants.searchPredicate2, objects, text)
        }

        self.fetchResultsController.fetchRequest.predicate = predicate
        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }

    func nextViewController(indexPath: IndexPath) -> UIViewController {

        let job = self[indexPath]
        switch self.expenseType {

        case .time:
            let viewModel = WorkTypeViewModel(job: job)
            return WorkTypeViewController(viewModel: viewModel)
        case .other, .driving:
            let viewModel = ExpenseTypeViewModel(job: job)
            return ExpenseTypeViewController(viewModel: viewModel)
        case .material:
            return UIViewController() // TODO: Impement
        }
    }
}
