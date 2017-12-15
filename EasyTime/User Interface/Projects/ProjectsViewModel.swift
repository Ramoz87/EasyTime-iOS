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

    static let entityName = "Job"
    static let sortDescriptor = "name"
    static let sectionName = "entityType"
    static let searchPredicate = "name CONTAINS[cd] %@"
}

class ProjectsViewModel: BaseViewModel {

    private let fetchResultsControllerCallbackReceiver: FetchedResultsControllerCallbackReceiver = FetchedResultsControllerCallbackReceiver()
    private lazy var fetchResultsController: NSFetchedResultsController<Job> = {

        return AppManager.sharedInstance.dataHelper.fetchedResultsController(entityName: Constants.entityName,
                                                                             sort: [Constants.sortDescriptor],
                                                                             sectionNameKeyPath:Constants.sectionName)
    }()

    var tableView: UITableView? {

        didSet {

            self.fetchResultsControllerCallbackReceiver.tableView = self.tableView
            do { try self.fetchResultsController.performFetch() } catch {}
            self.tableView?.reloadData()
        }
    }

    required init() {

        /*
        let context = AppManager.sharedInstance.dataHelper.mainContext
        for i in 1...10 {

            let job = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! Project
            job.jobId = "Project \(i)"
            job.name = "Project \(i)"
            job.entityType = "Project"
        }
        for i in 1...10 {

            let job = NSEntityDescription.insertNewObject(forEntityName: "Object", into: context) as! Object
            job.jobId = "Object \(i)"
            job.name = "Object \(i)"
            job.entityType = "Object"
        }
        for i in 1...10 {

            let job = NSEntityDescription.insertNewObject(forEntityName: "Order", into: context) as! Order
            job.jobId = "Order \(i)"
            job.name = "Order \(i)"
            job.entityType = "Order"
        }
        do { try context.save() } catch (let error){ print(error) } //TODO: REMOVE
        */

        super.init()
        self.fetchResultsController.delegate = self.fetchResultsControllerCallbackReceiver
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

        guard let sections = self.fetchResultsController.sections else { return "" }
        if section < sections.count { return sections[section].name }
        else { return "" }
    }

    func updateSearchResults(text: String?) {

        var predicate: NSPredicate?
        if let text = text, text.count > 0 {

            predicate = NSPredicate(format: Constants.searchPredicate, text)
        }
        self.fetchResultsController.fetchRequest.predicate = predicate
        do { try self.fetchResultsController.performFetch() } catch {}
        self.tableView?.reloadData()
    }

    func configure(cell: UITableViewCell, indexPath: IndexPath) {

        let job = self.fetchResultsController.object(at: indexPath)
        if let cell = cell as? ProjectTableViewCell {

            cell.lblID.text = job.jobId
            cell.lblName.text = job.name
        }
    }
}

fileprivate class FetchedResultsControllerCallbackReceiver: NSObject, NSFetchedResultsControllerDelegate {

    var tableView: UITableView?

    override init() {

    }

    //MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        self.tableView?.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        self.tableView?.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        switch type {
        case .insert:
            self.tableView?.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            self.tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        guard let indexPath = indexPath else { return }

        switch type {
        case .insert:
            self.tableView?.insertRows(at: [indexPath], with: .automatic)
        case .delete:
            self.tableView?.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            self.tableView?.deleteRows(at: [indexPath], with: .automatic)
            self.tableView?.insertRows(at: [indexPath], with: .automatic)
        case .update:
            self.tableView?.insertRows(at: [indexPath], with: .automatic)
        }
    }
}
