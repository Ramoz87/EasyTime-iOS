//
//  ProjectDetailsViewController.swift
//  EasyTime
//
//  Created by Sergei Kvasov on 1/5/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ProjectDetailsViewController: BaseViewController<ProjectDetailsViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.viewModel.title

        let controller = TabViewController()
        controller.viewControllers = self.viewModel.viewControllers()
        controller.tabView.backgroundColor = UIColor.et_blueColor
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        NSLayoutConstraint.activate([
            controller.view.safeLeadingAnchor.constraint(equalTo: self.view.safeLeadingAnchor),
            controller.view.safeTopAnchor.constraint(equalTo: self.view.safeTopAnchor),
            controller.view.safeTrailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor),
            controller.view.safeBottomAnchor.constraint(equalTo: self.view.safeBottomAnchor)
            ])
    }
}
