//
//  ProjectActivityViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let datePickerDoneButtonText = NSLocalizedString("Done", comment: "")
    static let dateFilterButtonDropDownIconSpacing: CGFloat = 8
    static let buttonCornerRadius: CGFloat = 4
    static let buttonBorderWidth: CGFloat = 1 / UIScreen.main.scale
    static let tableViewBorderWidth: CGFloat = 1 / UIScreen.main.scale
    static let tableViewBorderColor = UIColor.black.withAlphaComponent(0.3)
}

class ProjectActivityViewController: BaseViewController<ProjectActivityViewModel>, UITableViewDelegate, UITableViewDataSource, CollectionViewUpdateDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var btnDateFilter: InputButton!

    lazy var datePicker: UIDatePicker = {

        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(ProjectActivityViewController.didChangeDate(sender:)), for: .valueChanged)
        return picker
    }()

    lazy var dateFormatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .medium
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.collectionViewUpdateDelegate = self
        
        self.tableView.register(UINib(nibName: ProjectActivityTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ProjectActivityTableViewCell.reuseIdentifier)
        self.tableView.tableFooterView = UIView() //To hide separators of empty cells

        self.btnDateFilter.setTitle(self.dateFormatter.string(from: self.datePicker.date), for: .normal)
        self.btnDateFilter.inputView = self.datePicker
        self.btnDateFilter.inputAccessoryView = self.btnDateFilter.keyboardToolbar
        self.btnDateFilter.semanticContentAttribute = .forceRightToLeft
        self.btnDateFilter.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -Constants.dateFilterButtonDropDownIconSpacing)
        self.btnDateFilter.addDoneOnKeyboardWithTarget(self, action: #selector(ProjectsViewController.didTapDoneOnDatePicker(sender:)), titleText: Constants.datePickerDoneButtonText)

        for button in self.buttons {

            button.alignVertical()
            button.layer.borderWidth = Constants.buttonBorderWidth
            button.layer.cornerRadius = Constants.buttonCornerRadius
            button.layer.borderColor = UIColor.et_borderColor.cgColor
        }
    }

    //MARK: - UITableViewDelegate

    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectActivityTableViewCell.reuseIdentifier, for: indexPath) as! ProjectActivityTableViewCell
        let expense = self.viewModel[indexPath]
        cell.textLabel?.text = expense.name
        cell.detailTextLabel?.text = "\(expense.value)"

        return cell
    }

    //MARK: - Action handlers

    @IBAction func addTime(sender: Any) {

        let controller = self.viewModel.nextViewController(expenseType: .time)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func addMaterials(sender: Any) {

    }

    @IBAction func addExpenses(sender: Any) {

        let controller = self.viewModel.nextViewController(expenseType: .money)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func didChangeDate(sender: Any) {

        let dateString = self.dateFormatter.string(from: self.datePicker.date)
        self.btnDateFilter.setTitle(dateString, for: .normal)
    }

    @objc func didTapDoneOnDatePicker(sender: Any) {

        self.btnDateFilter.resignFirstResponder()
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
