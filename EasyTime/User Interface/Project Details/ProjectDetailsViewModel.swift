//
//  ProjectDetailsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let tabActivity = NSLocalizedString("ACTIVITY", comment: "")
    static let tabInfo = NSLocalizedString("INFORMATION", comment: "")
}

class ProjectDetailsViewModel: BaseViewModel {

    private let job: ETJob
    var title: String? {

        get { return self.job.number }
    }

    init(job: ETJob) {

        self.job = job
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    func viewControllers() -> [UIViewController] {

        let viewModel = ProjectActivityViewModel(job: self.job)
        let activityController = ProjectActivityViewController(viewModel: viewModel)
        activityController.title = Constants.tabActivity

        let infoController = ProjectInfoViewController()
        infoController.title = Constants.tabInfo

        return [activityController, infoController]
    }
}
