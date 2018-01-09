//
//  ProjectDetailsViewController.swift
//  EasyTime
//
//  Created by Sergei Kvasov on 1/5/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ProjectDetailsViewController: BaseViewController<ProjectDetailsViewModel>, TabViewDelegate {

    @IBOutlet weak var tabView: TabView!
    @IBOutlet weak var vPlaceholder: UIView!
    weak var viewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.viewModel.title

        let controller = self.viewModel.viewControllerForTab(at: self.tabView.selectedIndex)
        self.addViewController(controller: controller)
    }
    
    //MARK: - TabViewDelegate
    
    func numberOfItemsForTabView(tabView: TabView) -> Int {
    
        return self.viewModel.numberOfTabs()
    }
    
    func tabView(_ tabView: TabView, titleForItemAtIndex index: Int) -> String? {
        
        return self.viewModel.titleForTab(at: index)
    }
    
    func tabView(_ tabView: TabView, didSelectItemAtIndex index: Int) {

        let controller = self.viewModel.viewControllerForTab(at: index)
        self.addViewController(controller: controller)
    }

    func addViewController(controller: UIViewController?) {

        if let viewController = self.viewController {

            viewController.willMove(toParentViewController: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
        }

        if let controller = controller {

            self.addChildViewController(controller)
            self.vPlaceholder.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
            self.viewController = controller
            self.vPlaceholder.addConstraints([
                NSLayoutConstraint(item: controller.view, attribute: .leading, relatedBy: .equal, toItem: self.vPlaceholder, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: controller.view, attribute: .top, relatedBy: .equal, toItem: self.vPlaceholder, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: controller.view, attribute: .trailing, relatedBy: .equal, toItem: self.vPlaceholder, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: controller.view, attribute: .bottom, relatedBy: .equal, toItem: self.vPlaceholder, attribute: .bottom, multiplier: 1, constant: 0)
                ])
        }
    }
}
