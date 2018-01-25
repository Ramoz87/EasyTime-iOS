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

}

class ClientInfoViewController: BaseViewController<ClientInfoViewModel>, UITableViewDataSource, UITableViewDelegate, TabViewDelegate, CollectionViewUpdateDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var vHeader: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnSendEmail: UIButton!
    @IBOutlet weak var btnOpenMap: UIButton!
    @IBOutlet weak var btnCallPhone: UIButton!
    @IBOutlet weak var tabView: TabView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.viewModel.customer.companyName

        self.vHeader.backgroundColor = UIColor.et_blueColor

        self.tableView.register(UINib.init(nibName: ProjectTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ProjectTableViewCell.reuseIdentifier)
        self.tableView.register(UINib.init(nibName: OrderTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: OrderTableViewCell.reuseIdentifier)
        self.tableView.register(UINib.init(nibName: ObjectTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ObjectTableViewCell.reuseIdentifier)
        self.tableView.tableHeaderView = self.vHeader
        self.tableView.tableFooterView = UIView() //To hide separators of empty cells
        self.viewModel.collectionViewUpdateDelegate = self

        self.lblName.text = self.viewModel.customer.fullName
        self.lblAddress.text = self.viewModel.customer.address?.fullAddress
    }

    //MARK: - Action handlers

    @IBAction func didTapSendEmailButton(sender: Any) {

        if MFMailComposeViewController.canSendMail() {

            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["mail@gmail.com"]) //TODO: Customer email
            self.present(composeVC, animated: true, completion: nil)
        }
    }

    @IBAction func didTapOpenMapButton(sender: Any) {

        guard let fullAddress = self.viewModel.customer.address?.fullAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "http://maps.apple.com/?address=\(fullAddress)") else { return }
        let application = UIApplication.shared

        if application.canOpenURL(url) == true {

            application.open(url, options: [:], completionHandler: nil)
        }
    }

    @IBAction func didTapCallPhonelButton(sender: Any) {

        let phone = "12345678" // TODO:
        let application = UIApplication.shared
        if let url = URL(string: "tel://\(phone)"), application.canOpenURL(url) {

            application.open(url, options: [:], completionHandler: nil)
        }
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
        self.tableView.reloadData()
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

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}
