//
//  ProjectActivityViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ProjectActivityViewModel: BaseViewModel {

    private let job: ETJob

    init(job: ETJob) {

        self.job = job
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }
}
