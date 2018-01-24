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
    static let statusPickerDoneButtonText = NSLocalizedString("Done", comment: "")
    static let photosCollectionViewPadding: CGFloat = 10
}

class ProjectInfoViewController: BaseViewController<ProjectInfoViewModel>, UITableViewDelegate, UITableViewDataSource, ProjectInfoSectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddPhoto: UIButton!

    @IBOutlet weak var vTableViewHeader: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblbDate: UILabel!
    @IBOutlet weak var lblID: UILabel!

    @IBOutlet weak var vPhotosPlaceholder: UIView!
    @IBOutlet weak var btnAddPhotoSmall: UIButton!
    @IBOutlet weak var cvPhotos: UICollectionView!
    @IBOutlet weak var pcPhotos: UIPageControl!

    lazy var imagePickerController: UIImagePickerController = {

        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        return controller
    }()

    lazy var pvStatus: UIPickerView = {

        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()

    lazy var btnAddPhotoDashLineLayer: CAShapeLayer = {

        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = Constants.buttonBorderColor.cgColor
        borderLayer.lineDashPattern = Constants.buttonBorderDashPattern
        borderLayer.frame = self.btnAddPhoto.bounds
        borderLayer.fillColor = nil
        borderLayer.cornerRadius = Constants.buttonCornerRadius
        return borderLayer
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

        self.cvPhotos.layer.cornerRadius = Constants.buttonCornerRadius
        self.cvPhotos.register(UINib.init(nibName: ProjectPhotoCollectionViewCell.cellName, bundle: nil), forCellWithReuseIdentifier: ProjectPhotoCollectionViewCell.reuseIdentifier)

        self.btnAddPhotoSmall.alignVertical(spacing: Constants.buttonIconSpacing)

        if self.viewModel.photos.count == 0 {

            self.btnAddPhoto.layer.addSublayer(self.btnAddPhotoDashLineLayer)
            self.btnAddPhoto.alignVertical(spacing: Constants.buttonIconSpacing)
            self.btnAddPhoto.setTitle(Constants.buttonText, for: .normal)
        }
        else {

            self.btnAddPhoto.removeFromSuperview()
            self.vPhotosPlaceholder.isHidden = false
            self.pcPhotos.numberOfPages = self.viewModel.photos.count
            self.view.setNeedsLayout()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.updateAddPhotoButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.updateAddPhotoButton()

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

    func expandSection(section: Int, isExpanded: Bool) {

        let sectionInfo = self.viewModel[section]
        sectionInfo.isExpanded = isExpanded
        UIView.setAnimationsEnabled(false)
        self.tableView.reloadSections([section], with: .none)
        UIView.setAnimationsEnabled(true)
    }

    func updateAddPhotoButton() {

        if self.viewModel.photos.count == 0 {

            self.btnAddPhotoDashLineLayer.path = UIBezierPath(rect: self.btnAddPhoto.bounds).cgPath
        }
    }

    func updatePhotosPageControl() {

        if self.viewModel.photos.count > 0 {

            let index = Int(self.cvPhotos.contentOffset.x / (self.cvPhotos.contentSize.width / CGFloat(self.viewModel.photos.count)))
            self.pcPhotos.currentPage = index
        }
    }

    //MARK: - Action handlers

    @IBAction func didTapAddPhoto(sender: Any) {

        self.present(self.imagePickerController, animated: true, completion: nil)
    }

    @objc func didTapDoneOnStatusPicker(sender: UIButton) {

        self.view.endEditing(true)

        let index = self.pvStatus.selectedRow(inComponent: 0)
        let status = self.viewModel.statuses[index]
        self.viewModel.updateStatus(newStatus: status)
        self.expandSection(section: ProjectInfoSectionType.status.rawValue, isExpanded: false)
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //TODO: Implement
    }

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
            sectionView.delegate = nil

            if let status = self.viewModel.statuses.filter({ type -> Bool in
                return type.typeId == sectionInfo.job.statusId
            }).first {

                sectionView.lblDetails.text = status.name
                if let index = self.viewModel.statuses.index(of: status) {

                    self.pvStatus.selectRow(index, inComponent: 0, animated: false)
                }
            }
        }
        return sectionView
    }

    //MARK: - ProjectInfoSectionViewDelegate

    func didExpandProjectInfoSectionView(view: ProjectInfoSectionView) {

        if view.sectionIndex == ProjectInfoSectionType.customer.rawValue,
            let customer = self.viewModel.customer{

            let viewModel = ClientInfoViewModel(customer: customer)
            let controller = ClientInfoViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(controller, animated: true)
            self.expandSection(section: view.sectionIndex, isExpanded: false)
            return 
        }

        self.expandSection(section: view.sectionIndex, isExpanded: true)
    }

    func didCollapseProjectInfoSectionView(view: ProjectInfoSectionView) {

        self.expandSection(section: view.sectionIndex, isExpanded: false)
    }

    //MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {

            if self.viewModel.photos.count == 0 {

                self.btnAddPhoto.removeFromSuperview()
                self.vPhotosPlaceholder.isHidden = false
                self.view.setNeedsLayout()
            }
            self.viewModel.addPhoto(photo: photo)
            self.pcPhotos.numberOfPages = self.viewModel.photos.count
            self.cvPhotos.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: true, completion: nil)
    }

    //MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return self.viewModel.statuses.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return self.viewModel.statuses[row].name
    }

    //MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.viewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectPhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! ProjectPhotoCollectionViewCell
        cell.imageView.image = self.viewModel.photos[indexPath.item]
        return cell
    }

    //MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return self.vPhotosPlaceholder.frame.size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    //MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView == self.cvPhotos {

            self.updatePhotosPageControl()
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if scrollView == self.cvPhotos {

            self.updatePhotosPageControl()
        }
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        if scrollView == self.cvPhotos {

            self.updatePhotosPageControl()
        }
    }
}
