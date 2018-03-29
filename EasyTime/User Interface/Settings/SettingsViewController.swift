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
    static let help = NSLocalizedString("Help", comment: "")
    static let subject = NSLocalizedString("EasyTime Feedback", comment: "")
    static let btnSaveCornerRadius: CGFloat = 4
}

class SettingsViewController: BaseViewController<SettingsViewModel>, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var scPeriod: SegmentView!
    @IBOutlet weak var btnFullStatistic: UIButton!
    @IBOutlet weak var lbPeriod: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var btnHelp: UIBarButtonItem = {
        
        return UIBarButtonItem(title: Constants.help, style: .plain, target: self, action: #selector(self.showTutorial))
    }()
    
    lazy var btnLogout: UIBarButtonItem = {
        
        return UIBarButtonItem(image: UIImage(named: "exit")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.logout))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.btnLogout
        self.navigationItem.leftBarButtonItem = self.btnHelp
        
        self.btnFullStatistic.layer.cornerRadius = Constants.btnSaveCornerRadius
        
        
        self.collectionView.register(UINib.init(nibName: StatisticTimeCollectionViewCell.cellName, bundle: nil), forCellWithReuseIdentifier: StatisticTimeCollectionViewCell.reuseIdentifier)
        self.collectionView.register(UINib.init(nibName: StatisticExpenseCollectionViewCell.cellName, bundle: nil), forCellWithReuseIdentifier: StatisticExpenseCollectionViewCell.reuseIdentifier)
       
        if let user = AppManager.sharedInstance.user {
            lbName.text = user.fullName
            lbTitle.text = "Swiss1mobile"
        }
        else
        {
            lbName.text = ""
            lbTitle.text = ""
        }
    }
    
    //MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell?
        if indexPath.row == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticTimeCollectionViewCell.reuseIdentifier, for: indexPath) as! StatisticTimeCollectionViewCell
        }
        else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticExpenseCollectionViewCell.reuseIdentifier, for: indexPath) as! StatisticExpenseCollectionViewCell
        }

        return cell!
    }
    
    //MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = (indexPath.row == 0) ? StatisticTimeCollectionViewCell.height : StatisticExpenseCollectionViewCell.height
        let width = (collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    //MARK: - Action handlers
    
    @objc func logout() {
        AppManager.sharedInstance.logout()
    }
    
    @objc func showTutorial() {

        let controller = TutorialViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func onPeriodChanged(sender: Any) {
        
    }
    
    @IBAction func onFullStatClick(sender: Any) {
        
    }
}
