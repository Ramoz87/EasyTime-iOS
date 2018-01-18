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
    private let typeId: String
    private let name: String

    init(job: ETJob, type: ETType) {

        self.job = job
        self.typeId = type.typeId!
        
        if  let name = type.customName {
            self.name = name
        }
        else {
            self.name =  type.name!
        }
        super.init()
    }

    init(job: ETJob, expense: ETExpense) {
        
        self.job = job
        self.typeId = expense.typeId!
        self.name = expense.name!
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
