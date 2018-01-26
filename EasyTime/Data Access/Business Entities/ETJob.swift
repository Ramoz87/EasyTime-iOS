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
    var name: String?
    var number: String?
    var statusId: String?
    var typeId: String?
    var images: Files?
    var entityType: String?

    var objects: [String]? {
        get { return nil }
    }

    var members: [String]? {
        get {
            let members = self.job.members?.components(separatedBy: ",").filter {$0.count > 0}
            return members
        }
    }
    
    private let job: Job

    init(job: Job) {

        self.job = job
        self.currency = job.currency
        self.customerId = job.customerId
        self.date = job.date
        self.information = job.information
        self.jobId = job.jobId
        self.name = job.name
        self.number = job.number
        self.statusId = job.statusId
        self.typeId = job.typeId
        self.images = job.images
        self.entityType = job.entityType
    }
    
    func addExpense(expense: ETExpense) {
        
        let dbExpense: Expense = AppManager.sharedInstance.dataHelper.insertEntity()
        dbExpense.expenseId = expense.expenseId
        dbExpense.discount = expense.discount
        dbExpense.materialId = expense.materialId
        dbExpense.name = expense.name
        dbExpense.type = expense.type.rawValue
        dbExpense.value = expense.value
        dbExpense.date = expense.date
        dbExpense.workTypeId = expense.workTypeId
        dbExpense.typeId = expense.typeId
        dbExpense.unit = expense.unit
        
        
        if let fileUrl = expense.fileUrl {
            let file: Files = AppManager.sharedInstance.dataHelper.insertEntity()
            file.fileUrl = fileUrl.absoluteString
            file.fileId = UUID().uuidString
            file.name = fileUrl.lastPathComponent
            file.expense = dbExpense
        }
        
        self.job.addToExpenses(dbExpense)
    }

    func update() {

        self.job.statusId = self.statusId
    }
}


