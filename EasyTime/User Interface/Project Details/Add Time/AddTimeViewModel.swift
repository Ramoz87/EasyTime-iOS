//
//  AddTimeViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/12/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class AddTimeViewModel: BaseViewModel {

    private let job: ETJob

    var hours: String = "" {

        didSet {

            //TODO: Update hours
        }
    }
    var minutes: String = "" {

        didSet {

            //TODO: Update minutes
        }
    }

    init(job: ETJob) {

        self.job = job
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }
}
