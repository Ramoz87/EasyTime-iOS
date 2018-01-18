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
    private let type: ETType

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
    
    var time: Float {
        get {

            let hours = (self.hours as NSString).floatValue
            let minutes = (self.minutes as NSString).floatValue
            
            return hours * 60 + minutes
        }
    }

    init(job: ETJob, type: ETType) {

        self.job = job
        self.type = type
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }
    
    override func save() {
        let expense = ETExpense()
        expense.name = self.type.name
        expense.type = .time
        expense.value = self.time
        expense.workTypeId = type.typeId
        
        expense.save()
    }
}
