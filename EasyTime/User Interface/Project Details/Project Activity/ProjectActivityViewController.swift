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
}

class ProjectActivityViewController: BaseViewController<ProjectActivityViewModel>, UITableViewDelegate, UITableViewDataSource {

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

        self.tableView.register(UINib(nibName: ProjectActivityTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ProjectActivityTableViewCell.reuseIdentifier)

        self.btnDateFilter.setTitle(self.dateFormatter.string(from: self.datePicker.date), for: .normal)
        self.btnDateFilter.inputView = self.datePicker
        self.btnDateFilter.inputAccessoryView = self.btnDateFilter.keyboardToolbar
        self.btnDateFilter.semanticContentAttribute = .forceRightToLeft
        self.btnDateFilter.setImage(UIImage(named: "dropDownIcon"), for: .normal)
        self.btnDateFilter.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -Constants.dateFilterButtonDropDownIconSpacing)
        self.btnDateFilter.addDoneOnKeyboardWithTarget(self, action: #selector(ProjectsViewController.didTapDoneOnDatePicker(sender:)), titleText: Constants.datePickerDoneButtonText)
    }

    //MARK: - UITableViewDelegate

    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectActivityTableViewCell.reuseIdentifier, for: indexPath) as! ProjectActivityTableViewCell
        return cell
    }

    //MARK: - Action handlers

    @IBAction func addTime(sender: Any) {

    }

    @IBAction func addMaterials(sender: Any) {

    }

    @IBAction func addExpenses(sender: Any) {

    }

    @objc func didChangeDate(sender: Any) {

        let dateString = self.dateFormatter.string(from: self.datePicker.date)
        self.btnDateFilter.setTitle(dateString, for: .normal)
    }

    @objc func didTapDoneOnDatePicker(sender: Any) {

        self.btnDateFilter.resignFirstResponder()
    }
}
