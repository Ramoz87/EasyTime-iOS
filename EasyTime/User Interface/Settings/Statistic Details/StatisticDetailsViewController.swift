//
//  StatisticDetailsViewController.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 30/03/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

}

class StatisticDetailsViewController: BaseViewController<StatisticDetailsViewModel>, CollectionViewUpdateDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var vTop: UIView!
    @IBOutlet weak var vBottom: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbTotalTime: UILabel!
    @IBOutlet weak var lbTotalExpense: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vTop.layer.masksToBounds = false;
        vTop.layer.shadowOffset = CGSize(width: 0, height: 2)
        vTop.layer.shadowOpacity = 1
        vTop.layer.shadowRadius = 2.0
        vTop.layer.shadowColor = UIColor.et_shadowColor.cgColor
        
        vBottom.layer.masksToBounds = false;
        vBottom.layer.shadowOffset = CGSize(width: 0, height: -2)
        vBottom.layer.shadowOpacity = 1
        vBottom.layer.shadowRadius = 2.0
        vBottom.layer.shadowColor = UIColor.et_shadowColor.cgColor
        
        self.tableView.register(UINib(nibName: StatisticTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: StatisticTableViewCell.reuseIdentifier)
        self.tableView.tableFooterView = UIView()
        self.viewModel.collectionViewUpdateDelegate = self
        
        let date = Date()
        self.viewModel.updateFor(start: date, end: date)
    }

    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfObjects(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticTableViewCell.reuseIdentifier, for: indexPath) as! StatisticTableViewCell
        cell.statisticRecord = self.viewModel[indexPath]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //let sectionInfo = self.viewModel[indexPath.section]
        return StatisticTableViewCell.cellHeight//(sectionInfo.isExpanded == true && sectionInfo.isHidden == false) ? ProjectInfoTableViewCell.cellHeight : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return self.viewModel.numberOfSections() > 1 ?  StatisticSectionView.sectionHeight : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        guard self.viewModel.numberOfSections() > 1 else { return nil }
       
        let sectionView: StatisticSectionView = UIView.loadFromNib()
        sectionView.statisticInfo = self.viewModel[section]
        
        return sectionView
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - CollectionViewUpdateDelegate
    
    func didChangeContent() {
        
        self.tableView.reloadData()
    }
    
    func didChangeDataSet() {
        self.tableView.reloadData()
    }
}
