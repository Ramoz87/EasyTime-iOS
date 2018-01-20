//
//  ProjectInfoViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    
}

class ProjectInfoViewController: BaseViewController<ProjectInfoViewModel>, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: ProjectActivityTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ProjectActivityTableViewCell.reuseIdentifier)
        self.tableView.tableFooterView = UIView() //To hide separators of empty cells
    }

    //MARK: - UITableViewDelegate

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectActivityTableViewCell.reuseIdentifier, for: indexPath) as! ProjectActivityTableViewCell
        //cell.expense = self.viewModel[indexPath]

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return self.viewModel.heightForRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let sectionView = ProjectInfoSectionView.createFromXIB()
        sectionView.lblTitle.text = self.viewModel.titleForHeaderInSection(section: section)
        return sectionView
    }
}
