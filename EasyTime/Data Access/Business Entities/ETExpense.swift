//
//  ETExpense.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ETExpense {

    var discount: Float
    var expenseId: String?
    var materialId: String?
    var name: String?
    var type: Int32
    var value: Float
    var workTypeId: String?

    private let expense: Expense

    init(expense: Expense) {

        self.expense = expense
        self.discount = expense.discount
        self.expenseId = expense.expenseId
        self.materialId = expense.materialId
        self.name = expense.name
        self.type = expense.type
        self.value = expense.value
        self.workTypeId = expense.workTypeId
    }
}
