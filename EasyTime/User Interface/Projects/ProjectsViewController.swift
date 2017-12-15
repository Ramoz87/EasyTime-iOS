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

class ProjectsViewController: BaseViewController<ProjectsViewModel>, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CollectionViewUpdateDelegate {

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
        self.viewModel.collectionViewUpdateDelegate = self
    }

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.reuseIdentifier, for: indexPath) as! ProjectTableViewCell

        let job = self.viewModel[indexPath]
        if let project = job as? ETProject {

            cell.project = project
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return self.viewModel.titleForHeaderInSection(section: section)
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    //MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {

        self.viewModel.updateSearchResults(text: searchController.searchBar.text)
    }

    //MARK: - CollectionViewUpdateDelegate

    func didChangeObject(at indexPath: IndexPath?, for type: CollectionViewChangeType, newIndexPath: IndexPath?) {

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

    func didChangeSection(at sectionIndex: Int, for type: CollectionViewChangeType) {

        switch type {
            case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
            case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
            default:
            break
        }
    }

    func didChangeCollectionView() {

        self.tableView.reloadData()
    }

    func willChangeContent() {

        self.tableView.beginUpdates()
    }

    func didChangeContent() {

        self.tableView.endUpdates()
    }
}


