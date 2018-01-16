//
//  AddExpenseViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class AddExpenseViewModel: BaseViewModel {

    private let job: ETJob
    private let type: ETType

    init(job: ETJob, type: ETType) {

        self.job = job
        self.type = type
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }
}
