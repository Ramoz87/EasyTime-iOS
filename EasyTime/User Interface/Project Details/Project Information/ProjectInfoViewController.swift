//
//  ProjectInfoViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let buttonText = NSLocalizedString("Add Photo", comment: "")
    static let buttonCornerRadius: CGFloat = 4
    static let buttonBorderColor = UIColor(red: 109 / 255, green: 137 / 255, blue: 175 / 255, alpha: 1)
    static let buttonBorderDashPattern: [NSNumber] = [4, 4]
    static let buttonIconSpacing: CGFloat = 3
    static let statuses = [NSLocalizedString("Active", comment: ""), NSLocalizedString("Not active", comment: "")]
    static let statusPickerDoneButtonText = NSLocalizedString("Done", comment: "")
}

class ProjectInfoViewController: BaseViewController<ProjectInfoViewModel>, UITableViewDelegate, UITableViewDataSource, ProjectInfoSectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var vTableViewHeader: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblbDate: UILabel!
    @IBOutlet weak var lblID: UILabel!

    lazy var imagePickerController: UIImagePickerController = {

        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = self
        return controller
    }()

    lazy var pvStatus: UIPickerView = {

        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblName.text = self.viewModel.job.name
        self.lblDescription.text = self.viewModel.job.information
        self.lblDescription.preferredMaxLayoutWidth = self.view.frame.size.width
        self.lblID.text = self.viewModel.job.number
        if let project = self.viewModel.job as? ETProject, let dateStart = project.dateStart, let dateEnd = project.dateEnd {

            let dateFormatter = DateFormatter()
            self.lblbDate.text = dateFormatter.string(from: dateStart as Date) + " - " + dateFormatter.string(from: dateEnd as Date)
        }

        self.tableView.register(UINib(nibName: ProjectInfoTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ProjectInfoTableViewCell.reuseIdentifier)
        self.tableView.tableHeaderView = self.vTableViewHeader
        self.tableView.tableFooterView = UIView() //To hide separators of empty cells

        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = Constants.buttonBorderColor.cgColor
        borderLayer.lineDashPattern = Constants.buttonBorderDashPattern
        borderLayer.frame = self.btnAddPhoto.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(rect: self.btnAddPhoto.bounds).cgPath
        borderLayer.cornerRadius = Constants.buttonCornerRadius
        self.btnAddPhoto.layer.addSublayer(borderLayer)
        self.btnAddPhoto.alignVertical(spacing: Constants.buttonIconSpacing)
        self.btnAddPhoto.setTitle(Constants.buttonText, for: .normal)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
    }

    //MARK: - Action handlers

    @IBAction func didTapAddPhoto(sender: Any) {

        self.present(self.imagePickerController, animated: true, completion: nil)
    }

    @objc func didTapDoneOnStatusPicker(sender: UIButton) {

        self.view.endEditing(true)
    }

    //MARK: - UITableViewDelegate

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel[section].numberOfObjects()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectInfoTableViewCell.reuseIdentifier, for: indexPath) as! ProjectInfoTableViewCell
        cell.label?.text = self.viewModel[indexPath.section].titleForObject(at: indexPath.row)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let sectionInfo = self.viewModel[indexPath.section]
        return (sectionInfo.isExpanded == true && sectionInfo.isHidden == false) ? ProjectInfoTableViewCell.cellHeight : 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return self.viewModel[section].isHidden ? 0 : ProjectInfoSectionView.sectionHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let sectionInfo = self.viewModel[section]
        let sectionView = ProjectInfoSectionView.createFromXIB()
        sectionView.delegate = self
        sectionView.sectionIndex = section
        sectionView.isExpanded = sectionInfo.isExpanded
        sectionView.lblTitle.text = sectionInfo.sectionTitle()

        if sectionInfo.type == .status {

            sectionView.button.inputView = self.pvStatus
            sectionView.button.inputAccessoryView = sectionView.button.keyboardToolbar
            sectionView.button.addDoneOnKeyboardWithTarget(self, action: #selector(ProjectInfoViewController.didTapDoneOnStatusPicker(sender:)), titleText: Constants.statusPickerDoneButtonText)
        }
        return sectionView
    }

    //MARK: - ProjectInfoSectionViewDelegate

    func didExpandProjectInfoSectionView(view: ProjectInfoSectionView) {

        let sectionInfo = self.viewModel[view.sectionIndex]
        sectionInfo.isExpanded = true
        self.tableView.reloadSections([view.sectionIndex], with: .automatic)
    }

    func didCollapseProjectInfoSectionView(view: ProjectInfoSectionView) {

        let sectionInfo = self.viewModel[view.sectionIndex]
        sectionInfo.isExpanded = false
        self.tableView.reloadSections([view.sectionIndex], with: .automatic)
    }

    //MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            //self.viewModel.photo = image
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: true, completion: nil)
    }

    //MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }

    //MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return Constants.statuses.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return Constants.statuses[row]
    }
}
