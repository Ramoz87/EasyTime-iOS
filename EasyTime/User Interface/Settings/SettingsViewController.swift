//
//  SettingsViewController.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 07/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import MessageUI

fileprivate struct Constants
{
    static let feedbackEmail = "ramoz87@gmail.com"
    static let subject = NSLocalizedString("EasyTime Feedback", comment: "")
}

class SettingsViewController: BaseViewController<SettingsViewModel>, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbAppVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header: SettingViewHeader = UIView.loadFromNib()
        header.user = AppManager.sharedInstance.user
        self.tableView.tableHeaderView = header
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib.init(nibName: SettingViewCell.cellName, bundle: nil), forCellReuseIdentifier: SettingViewCell.reuseIdentifier)
        
        self.lbAppVersion.text = self.viewModel.appVersionString
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewCell.reuseIdentifier, for: indexPath) as! SettingViewCell
        cell.settingItem = self.viewModel[indexPath]
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0: 
            self.showTutorial()
        case 1:
           self.showEmailComposer()
        case 2:
            self.logout()
        default: break
            
        }
    }
    
    //MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Action handlers
    
    func logout() {
        AppManager.sharedInstance.logout()
    }
    
    func showEmailComposer() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([Constants.feedbackEmail])
            composeVC.setSubject(Constants.subject)
            self.present(composeVC, animated: true, completion: nil)
        }
    }

    func showTutorial() {

        let controller = TutorialViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
