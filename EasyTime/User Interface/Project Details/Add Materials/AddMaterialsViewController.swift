//
//  AddMaterialsViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/19/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let titleText = NSLocalizedString("Choose materials", comment: "")
}

class AddMaterialsViewController: BaseViewController<AddMaterialsViewModel>, UITableViewDelegate, UITableViewDataSource, CollectionViewUpdateDelegate, AddMaterialsTableViewCellControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    let numberInputViewController = NumberInputViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.titleText

        self.tableView.register(UINib(nibName: AddMaterialsTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: AddMaterialsTableViewCell.reuseIdentifier)
        self.tableView.tableFooterView = UIView() //To hide separators of empty cells
    }

    //MARK: - AddMaterialsTableViewCellControllerDelegate

    func inputViewController(for cell: AddMaterialsTableViewCell) -> UIInputViewController? {

        return self.numberInputViewController
    }

    //MARK: - UITableViewDelegate

    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: AddMaterialsTableViewCell.reuseIdentifier, for: indexPath) as! AddMaterialsTableViewCell
        let material = self.viewModel[indexPath]
        let cellController = self.viewModel.dequeueTableViewCellController(for: material)
        cellController.delegate = self
        cellController.cell = cell
        return cell
    }

    //MARK: - CollectionViewUpdateDelegate

    func didChangeObject(at indexPath: IndexPath?, for type: CollectionViewChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if  let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if  let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if  let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if  let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if  let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
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
