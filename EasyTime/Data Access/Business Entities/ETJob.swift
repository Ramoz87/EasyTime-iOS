//
//  ETJob.swift
//  EasyTime
//
//  Created by Mobexs on 12/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ETJob {

    var currency: String?
    var customerId: String?
    var date: NSDate?
    var information: String?
    var jobId: String?
    var members: String?
    var name: String?
    var number: String?
    var statusId: String?
    var typeId: String?
    var images: Files?
    var entityType: String?

    lazy var expenses: [ETExpense]? = {

        return self.job.expenses?.map({ expense -> ETExpense in
            return ETExpense(expense: expense as? Expense)
        })
    }()

    private let job: Job

    init(job: Job) {

        self.job = job
        self.currency = job.currency
        self.customerId = job.customerId
        self.date = job.date
        self.information = job.information
        self.jobId = job.jobId
        self.members = job.members
        self.name = job.name
        self.number = job.number
        self.statusId = job.statusId
        self.typeId = job.typeId
        self.images = job.images
        self.entityType = job.entityType
    }
}


