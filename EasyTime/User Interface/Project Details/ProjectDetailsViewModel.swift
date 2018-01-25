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

    let job: ETJob
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

        let activityViewModel = ProjectActivityViewModel(job: self.job)
        let activityController = ProjectActivityViewController(viewModel: activityViewModel)
        activityController.title = Constants.tabActivity

        let infoViewModel = ProjectInfoViewModel(job: self.job)
        let infoController = ProjectInfoViewController(viewModel: infoViewModel)
        infoController.title = Constants.tabInfo

        return [activityController, infoController]
    }
}
