//
//  ETExpense.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

enum ETExpenseType: Int32 {

    case time
    case material
    case driving
    case other
}

class ETExpense {

    var discount: Float = 0
    var expenseId: String?
    var materialId: String?
    var name: String?
    var type: ETExpenseType = .other
    var date: Date?
    var value: Float = 0
    var workTypeId: String?
    var typeId: String?

    var formattedValue: String {
        get {
            switch type {
            case .time:
                let hours = self.value / 60
                let minutes = self.value.truncatingRemainder(dividingBy: 60)
                
                return String(format: "%02d:%02d", Int(hours), Int(minutes))
            default:
                return "\(self.value)"
            }
        }
    }
    
    private var expense: Expense?
    
    init(expense: Expense?) {
        
        self.expense = expense
        if  let expense = expense {
            self.discount = expense.discount
            self.expenseId = expense.expenseId
            self.materialId = expense.materialId
            self.name = expense.name
            self.type = ETExpenseType(rawValue:expense.type)!
            self.value = expense.value
            self.date = expense.date
            self.workTypeId = expense.workTypeId
            self.typeId = expense.typeId
        }
    }
    
    convenience init() {
        self.init(expense: nil)
        
        self.expenseId = UUID().uuidString
        self.date = Date()
    }
    
    func save() {
        
        if self.expense == nil {
            self.expense = AppManager.sharedInstance.dataHelper.insertEntity()
        }
        
        if let expense = self.expense {
            expense.expenseId = self.expenseId
            expense.discount = self.discount
            expense.materialId = self.materialId
            expense.name = self.name
            expense.type = self.type.rawValue
            expense.value = self.value
            expense.date = self.date
            expense.workTypeId = self.workTypeId
            expense.typeId = self.typeId
        }

        AppManager.sharedInstance.dataHelper.save { (error) in
            
        }
    }
    
    func remove() {
        
        guard let expense = self.expense  else {
            return
        }
        
        AppManager.sharedInstance.dataHelper.delete(data: [expense]) { (error) in
            
        }
    }

}
