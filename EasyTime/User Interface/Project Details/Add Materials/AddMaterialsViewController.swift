//
//  AddMaterialsViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/19/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let titleText = NSLocalizedString("Materials", comment: "")
    static let btnSaveText = NSLocalizedString("ADD", comment: "")
    static let btnSaveTextFormat = NSLocalizedString("ADD %d MATERIALS", comment: "")
    static let btnSaveCornerRadius: CGFloat = 4

}

class AddMaterialsViewController: BaseViewController<AddMaterialsViewModel>, UITableViewDelegate, UITableViewDataSource, CollectionViewUpdateDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSave: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.titleText

        self.tableView.register(UINib(nibName: AddMaterialsTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: AddMaterialsTableViewCell.reuseIdentifier)

        self.btnSave.layer.cornerRadius = Constants.btnSaveCornerRadius
        self.btnSave.setTitle(Constants.btnSaveText, for: .normal)
    }
    
    private func updateButtonTitle(with selectedCount: Int){
        let title = (selectedCount > 0) ? String(format: Constants.btnSaveTextFormat, selectedCount) : Constants.btnSaveText
        self.btnSave.setTitle(title, for: .normal)
    }

    //MARK: - Action handlers

    @IBAction func didClickSaveButton(sender: Any) {

        if self.viewModel.hasMaterialsToAdd {
            self.viewModel.save()
            if let vc = self.navigationController?.viewControllers[1] {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.updateButtonTitle(with: self.viewModel.select(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.updateButtonTitle(with: self.viewModel.deselect(at: indexPath))
    }
    
    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: AddMaterialsTableViewCell.reuseIdentifier, for: indexPath) as! AddMaterialsTableViewCell
        cell.material = self.viewModel[indexPath]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
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
