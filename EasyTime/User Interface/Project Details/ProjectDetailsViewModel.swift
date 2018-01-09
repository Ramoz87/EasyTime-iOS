//
//  ProjectDetailsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

private enum ProjectDetailsMode: Int {

    case activity
    case information

    func count() -> Int {

        return ProjectDetailsMode.information.hashValue + 1
    }

    static func title(for mode: ProjectDetailsMode) -> String {

        switch mode {
        case .activity:
            return NSLocalizedString("ACTIVITY", comment: "")
        case .information:
            return NSLocalizedString("INFORMATION", comment: "")
        }
    }
}

class ProjectDetailsViewModel: BaseViewModel {

    private var mode: ProjectDetailsMode = .activity
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

    func numberOfTabs() -> Int {

        return self.mode.count()
    }

    func titleForTab(at index: Int) -> String? {

        if let mode = ProjectDetailsMode(rawValue: index) {

            return ProjectDetailsMode.title(for: mode)
        }
        return nil
    }

    func viewControllerForTab(at index: Int) -> UIViewController? {

        if let mode = ProjectDetailsMode(rawValue: index) {

            switch mode {

            case .activity:
                let viewModel = ProjectActivityViewModel(job: self.job)
                return ProjectActivityViewController(viewModel: viewModel)
            case .information:
                return ProjectInfoViewController()
            }
        }
        return nil
    }
}
