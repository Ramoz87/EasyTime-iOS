//
//  ClientInfoViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/24/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import MessageUI
import MapKit

fileprivate struct Constants {

    static let tableViewContentInset = UIEdgeInsets(top: 168, left: 0, bottom: 0, right: 0)
    static let statusPredicate = "type = 'STATUS'"
}

class ClientInfoViewController: BaseViewController<ClientInfoViewModel>, UITableViewDataSource, UITableViewDelegate, TabViewDelegate, CollectionViewUpdateDelegate, MFMailComposeViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ClientInfoCollectionViewCellDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var tableBackgroundOverlayView: UIView!
    @IBOutlet weak var tabView: TabView!
    @IBOutlet weak var tvJobs: UITableView!
    @IBOutlet weak var cvContacts: UICollectionView!

    private lazy var jobStatuses: [Type]? = {

        do {
            let statuses: [Type]? = try AppManager.sharedInstance.dataHelper.fetchData(predicate: NSPredicate(format: Constants.statusPredicate))
            return statuses
        }
        catch {
            return nil
        }
    }()

    private lazy var dateFormatter: DateFormatter = {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.viewModel.customer.companyName

        self.tableBackgroundView.backgroundColor = UIColor.et_blueColor

        self.tvJobs.register(UINib.init(nibName: JobTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: JobTableViewCell.reuseIdentifier)
        self.tvJobs.tableHeaderView = self.tabView
        self.tvJobs.tableFooterView = UIView() //To hide separators of empty cells
        self.tvJobs.contentInset = Constants.tableViewContentInset
        self.tvJobs.backgroundView = self.tableBackgroundView
        self.viewModel.collectionViewUpdateDelegate = self

        self.cvContacts.register(UINib.init(nibName: ClientInfoCollectionViewCell.cellName, bundle: nil), forCellWithReuseIdentifier: ClientInfoCollectionViewCell.reuseIdentifier)

        NSLayoutConstraint.activate( [NSLayoutConstraint(item: self.tableBackgroundOverlayView, attribute: .top, relatedBy: .equal, toItem: self.tabView, attribute: .bottom, multiplier: 1, constant: 0)])
    }

    //MARK: - TabViewDelegate

    func numberOfItemsForTabView(tabView: TabView) -> Int {

        return self.viewModel.numberOfTabs()
    }

    func tabView(_ tabView: TabView, titleForItemAtIndex index: Int) -> String? {

        return self.viewModel.titleForTab(at: index)
    }

    func tabView(_ tabView: TabView, didSelectItemAtIndex index: Int) {

        self.viewModel.selectedTabIndex = index
        self.tvJobs.reloadData()
    }

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: JobTableViewCell.reuseIdentifier, for: indexPath) as! JobTableViewCell
        let job = self.viewModel[indexPath]

        var statusName: String?
        if let status = self.jobStatuses?.filter({ status-> Bool in
            return status.typeId == job.statusId
        }).first {

            statusName = status.name
        }

        cell.job = job
        cell.lblStatus.text = statusName

        if let date = job.date {
            cell.lblDate.text = self.dateFormatter.string(from: date as Date)
        }
        else {
            cell.lblDate.text = nil
        }

        return cell
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }

    //MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let count = self.viewModel.customer.contacts?.count else { return 0 }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClientInfoCollectionViewCell.reuseIdentifier, for: indexPath) as! ClientInfoCollectionViewCell
        cell.delegate = self
        let contact = self.viewModel.customer.contacts?[indexPath.item]
        cell.contact = contact
        cell.lblName.text = self.viewModel.customer.fullName
        cell.lblAddress.text = self.viewModel.customer.address?.fullAddress

        if let email = contact?.email {

            cell.btnSendEmail.isEnabled = email.count > 0
        }
        else {

            cell.btnSendEmail.isEnabled = false
        }

        if let phone = contact?.phone {

            cell.btnCallPhone.isEnabled = phone.count > 0
        }
        else {

            cell.btnCallPhone.isEnabled = false
        }

        return cell
    }

    //MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return self.cvContacts.frame.size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    //MARK: - ClientInfoCollectionViewCellDelegate

    func clientInfoCollectionViewCellDidTapSendEmail(cell: ClientInfoCollectionViewCell) {

        if let contact = cell.contact, MFMailComposeViewController.canSendMail() == true {

            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([contact.email!]) 
            self.present(composeVC, animated: true, completion: nil)
        }
    }

    func clientInfoCollectionViewCellDidTapOpenMap(cell: ClientInfoCollectionViewCell) {

        guard let fullAddress = self.viewModel.customer.address?.fullAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "http://maps.apple.com/?address=\(fullAddress)") else { return }
        let application = UIApplication.shared

        if application.canOpenURL(url) == true {

            application.open(url, options: [:], completionHandler: nil)
        }
    }

    func clientInfoCollectionViewCellDidTapCallPhone(cell: ClientInfoCollectionViewCell) {

        if let phone = cell.contact?.phone {

            let phone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            let application = UIApplication.shared
            if let url = URL(string: "tel://\(phone)"), application.canOpenURL(url) {

                application.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    //MARK: - CollectionViewUpdateDelegate

    func didChangeObject(at indexPath: IndexPath?, for type: CollectionViewChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if  let indexPath = newIndexPath {
                self.tvJobs.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if  let indexPath = indexPath {
                self.tvJobs.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if  let indexPath = indexPath {
                self.tvJobs.deleteRows(at: [indexPath], with: .automatic)
            }
            if  let indexPath = newIndexPath {
                self.tvJobs.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if  let indexPath = indexPath {
                self.tvJobs.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }

    func didChangeSection(at sectionIndex: Int, for type: CollectionViewChangeType) {

        switch type {
        case .insert:
            self.tvJobs.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            self.tvJobs.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }

    func willChangeContent() {

        self.tvJobs.beginUpdates()
    }

    func didChangeContent() {

        self.tvJobs.endUpdates()
    }

    func didChangeDataSet() {
        self.tvJobs.reloadData()
    }

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}
