//
//  ObjectsViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let titleText = NSLocalizedString("Objects", comment: "")
    static let searchBarPlaceholder = NSLocalizedString("Search", comment: "")
}

class ObjectsViewController: BaseViewController<ObjectsViewModel>, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CollectionViewUpdateDelegate {

    @IBOutlet weak var tableView: UITableView!

    lazy var searchController: UISearchController = {

        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.placeholder = Constants.searchBarPlaceholder
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.titleText

        self.tableView.register(UINib(nibName: ObjectTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ObjectTableViewCell.reuseIdentifier)
        self.tableView.tableFooterView = UIView() //To hide separators of empty cells
        
        self.viewModel.collectionViewUpdateDelegate = self

        if #available(iOS 11.0, *) {

            self.navigationItem.searchController = self.searchController
        }
        else {

            self.tableView.tableHeaderView = self.searchController.searchBar
            self.tableView.contentOffset = CGPoint(x: 0, y: self.searchController.searchBar.frame.height)
        }
    }

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ObjectTableViewCell.reuseIdentifier, for: indexPath) as! ObjectTableViewCell

        let object = self.viewModel[indexPath]
        cell.object = object

        return cell
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {

        return self.viewModel.sectionForSectionIndexTitle(title, at: index)
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {

        return self.viewModel.sectionIndexTitles()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        guard let title = self.viewModel.sectionIndexTitles()?[section] else { return nil }
        return title
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let job = self.viewModel[indexPath] {

            let viewModel = AddTimeViewModel(job: job)
            let controller = AddTimeViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }

    //MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {

        self.viewModel.updateSearchResults(text: self.searchController.searchBar.text)
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
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
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

    func willChangeContent() {

        self.tableView.beginUpdates()
    }

    func didChangeContent() {

        self.tableView.endUpdates()
    }

    func didChangeDataSet() {
        self.tableView.reloadData()
    }
}
