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
    static let searchBarPlaceholder = NSLocalizedString("Search by name", comment: "")
    static let datePickerDoneButtonText = NSLocalizedString("Date of job", comment: "")
    static let dateFilterButtonDropDownIconSpacing: CGFloat = 8
}

class ProjectsViewController: BaseViewController<ProjectsViewModel>, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CollectionViewUpdateDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchController: UISearchController = {

        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.placeholder = Constants.searchBarPlaceholder
        return controller
    }()

    lazy var datePicker: UIDatePicker = {

        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(ProjectsViewController.didChangeDate(sender:)), for: .valueChanged)
        return picker
    }()

    lazy var dateFilterButton: InputButton = {
        
        let button = InputButton()
        button.inputView = self.datePicker
        button.inputAccessoryView = button.keyboardToolbar
        button.semanticContentAttribute = .forceRightToLeft
        button.setImage(UIImage(named: "dropDownWhiteIcon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -Constants.dateFilterButtonDropDownIconSpacing)
        button.addDoneOnKeyboardWithTarget(self, action: #selector(ProjectsViewController.didTapDoneOnDatePicker(sender:)), titleText: Constants.datePickerDoneButtonText)
        return button
    }()
    
    var selectedDate: Date {
        get {
            return self.datePicker.date
        }
        set {
            self.datePicker.date = newValue
            self.dateFilterButton.setTitle(newValue.toRelativeString(), for: .normal)
            self.dateFilterButton.sizeToFit()
            
            let searchString = self.searchController.searchBar.text
            self.viewModel.updateSearchResults(date: newValue, text: searchString)
        }
    }

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
        self.tableView.register(UINib.init(nibName: OrderTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: OrderTableViewCell.reuseIdentifier)
        self.tableView.register(UINib.init(nibName: ObjectTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ObjectTableViewCell.reuseIdentifier)
        self.viewModel.collectionViewUpdateDelegate = self

        self.navigationItem.titleView = self.dateFilterButton
        self.selectedDate = Date();
    }

    //MARK: - Action handlers

    @objc func didChangeDate(sender: Any) {
        self.selectedDate = self.datePicker.date
    }

    @objc func didTapDoneOnDatePicker(sender: Any) {

        self.dateFilterButton.resignFirstResponder()
    }

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell?
        let job = self.viewModel[indexPath]
        if let project = job as? ETProject {
            let projectCell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.reuseIdentifier, for: indexPath) as! ProjectTableViewCell
            projectCell.project = project
            cell = projectCell
        }
        
        if let order = job as? ETOrder {
            let orderCell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseIdentifier, for: indexPath) as! OrderTableViewCell
            orderCell.order = order
            cell = orderCell
        }
        
        if let object = job as? ETObject {
            let objectCell = tableView.dequeueReusableCell(withIdentifier: ObjectTableViewCell.reuseIdentifier, for: indexPath) as! ObjectTableViewCell
            objectCell.object = object
            cell = objectCell
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return self.viewModel.titleForHeaderInSection(section: section)
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let job = self.viewModel[indexPath]

        let viewModel = ProjectDetailsViewModel(job: job)
        let controller = ProjectDetailsViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }

    //MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {

        self.viewModel.updateSearchResults(date: self.selectedDate, text: self.searchController.searchBar.text)
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


