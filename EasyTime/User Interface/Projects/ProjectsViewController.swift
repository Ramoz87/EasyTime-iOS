//
//  ProjectsViewController.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 07/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants
{
    static let searchBarPlaceholder = NSLocalizedString("Search", comment: "")
}

class ProjectsViewController: BaseViewController<ProjectsViewModel>, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchController: UISearchController = {

        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.placeholder = Constants.searchBarPlaceholder
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {

            self.navigationItem.searchController = self.searchController
        }
        else {

            self.tableView.tableHeaderView = self.searchController.searchBar
            self.tableView.contentOffset = CGPoint(x: 0, y: self.searchController.searchBar.frame.height)
        }

        self.tableView.register(UINib.init(nibName: ProjectTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ProjectTableViewCell.reuseIdentifier)

        self.viewModel.fetchResultsController.delegate = self
        do { try self.viewModel.fetchResultsController.performFetch() } catch {}
    }

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        guard let count = self.viewModel.fetchResultsController.sections?.count else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let count = self.viewModel.fetchResultsController.fetchedObjects?.count else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.reuseIdentifier, for: indexPath) as! ProjectTableViewCell
        let job = self.viewModel.fetchResultsController.object(at: indexPath) as! Job

        cell.lblID.text = job.jobId
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        guard let sections = self.viewModel.fetchResultsController.sections else { return "" }
        guard let job = sections.first?.objects?.first as? Job else { return "" }
        return "SECTION NAME" // TODO: type
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    //MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {

        var predicate: NSPredicate?
        if let text = searchController.searchBar.text, text.characters.count > 0 {

            predicate = NSPredicate(format: "jobId CONTAINS[cd] %@", text)
        }
        self.viewModel.fetchResultsController.fetchRequest.predicate = predicate
        do { try self.viewModel.fetchResultsController.performFetch() } catch {}
        self.tableView.reloadData()
    }

    //MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        self.tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        self.tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        guard let indexPath = indexPath else { return }

        switch type {
        case .insert:
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        case .update:
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}


