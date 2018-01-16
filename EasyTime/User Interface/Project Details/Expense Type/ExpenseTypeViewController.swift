//
//  ExpenseTypeViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let titleText = NSLocalizedString("Expenses", comment: "")
    static let searchBarPlaceholder = NSLocalizedString("Search", comment: "")
    static let newExpenseTitlePlaceholderText = NSLocalizedString("Title", comment: "")
    static let newExpenseTitleText = NSLocalizedString("New expense", comment: "")
    static let newExpenseMessageText = NSLocalizedString("Enter name for this expense", comment: "")
    static let saveText = NSLocalizedString("Save", comment: "")
    static let cancelText = NSLocalizedString("Cancel", comment: "")
    static let newExpenseTitlePlaceholderFontSize: CGFloat = 13
}

class ExpenseTypeViewController: BaseViewController<ExpenseTypeViewModel>, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CollectionViewUpdateDelegate {

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

        self.tableView.register(UINib(nibName: ExpenseTypeTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ExpenseTypeTableViewCell.reuseIdentifier)
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

    func showNewExpenseTypeUI() {

        let controller = UIAlertController(title: Constants.newExpenseTitleText, message: Constants.newExpenseMessageText, preferredStyle: .alert)

        controller.addTextField(configurationHandler: { textField in

            textField.placeholder = Constants.newExpenseTitlePlaceholderText
            textField.font = UIFont.systemFont(ofSize: Constants.newExpenseTitlePlaceholderFontSize)
        })

        let cancelAction = UIAlertAction(title: Constants.cancelText, style: .cancel, handler: { action in

            controller.dismiss(animated: true, completion: nil)
        })
        controller.addAction(cancelAction)

        let saveAction = UIAlertAction(title: Constants.saveText, style: .default, handler: { action in

            if let textField = controller.textFields?.first {

                let name = textField.text

                //TODO: Save new expense
                // self.showAddExpenseViewController(for: type)
            }
            controller.dismiss(animated: true, completion: nil)
        })
        controller.addAction(saveAction)

        self.present(controller, animated: true, completion: nil)
    }

    func showAddExpenseViewController(for type: ETType) {

        let viewModel = AddExpenseViewModel(job: self.viewModel.job, type: type)
        let controller = AddExpenseViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTypeTableViewCell.reuseIdentifier, for: indexPath) as! ExpenseTypeTableViewCell

        let type = self.viewModel[indexPath]
        cell.textLabel?.text = type?.name

        return cell
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {

        return self.viewModel.sectionForSectionIndexTitle(title, at: index)
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {

        return self.viewModel.sectionIndexTitles()
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let type = self.viewModel[indexPath] {

            if type.typeId == AppManager.sharedInstance.otherExpenseTypeId {

                self.showNewExpenseTypeUI()
            }
            else {

                self.showAddExpenseViewController(for: type)
            }
        }
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
