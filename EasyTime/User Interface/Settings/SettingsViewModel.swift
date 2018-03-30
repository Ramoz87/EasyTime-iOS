//
//  SettingsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 12/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {
    
    static let sortDescriptor = "name"
    static let timePredicate = NSPredicate(format: "type = 0")
    static let expensePredicate = NSPredicate(format: "type = 3")
    static let currency = "CHF"
    static let periodDay = 480
    static let periodWeek = 2400
    static let periodMonth = 9600
}

enum StatPeriod: Int {
    case day
    case week
    case month
}

class SettingsViewModel: BaseViewModel {

    var expenseStatistic: ExpenseStatistic {
        get {
            guard let expenses = fetchResultsControllerExpense.fetchedObjects, expenses.count > 0 else { return ExpenseStatistic(0) }
            guard let value = (expenses as NSArray).value(forKeyPath: "@sum.value") as? Float else { return ExpenseStatistic(0) }
            let stat = ExpenseStatistic(value)
            return stat
        }
    }
    
    var timeStatistic: TimeStatistic {
        get {
            guard let times = fetchResultsControllerTime.fetchedObjects, times.count > 0 else { return TimeStatistic(value: 0, periodValue: 40) }
            guard let value = (times as NSArray).value(forKeyPath: "@sum.value") as? Float else { return TimeStatistic(value: 0, periodValue: 40) }
            let stat = TimeStatistic(value: value, periodValue: Float(periodValue))
            return stat
        }
    }
    
    var periodValue: Int = Constants.periodDay
    var periodString: String?
    
    private lazy var fetchResultsControllerTime: NSFetchedResultsController<Expense> = {
        
        let fetchedResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],predicate: Constants.timePredicate)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private lazy var fetchResultsControllerExpense: NSFetchedResultsController<Expense> = {
        
        let fetchedResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor], predicate: Constants.expensePredicate)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    func updateForPeriod(period: StatPeriod, date: Date) {
        do {
            
            var start = date
            var end = date
            
            switch period {
            case .day:
                start = date.startOfDay
                end = date.endOfDay
                periodString = date.toDefaultString()
                periodValue = Constants.periodDay
                break
            case .week:
                start = date.startOfWeek
                end = date.endOfWeek
                periodString = String(format: "%@ - %@", start.toDefaultString(), end.toDefaultString())
                periodValue = Constants.periodWeek
                break
            case .month:
                start = date.startOfMonth
                end = date.endOfMonth
                periodString = date.toString("LLLL")
                periodValue = Constants.periodMonth
                break
            }
            
            let datePredicate = NSPredicate(format:"date >= %@ && date <= %@", start as NSDate, end as NSDate)
            
            self.fetchResultsControllerTime.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Constants.timePredicate, datePredicate])
            try self.fetchResultsControllerTime.performFetch()
            
            self.fetchResultsControllerExpense.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Constants.expensePredicate, datePredicate])
            try self.fetchResultsControllerExpense.performFetch()

            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
}

struct ExpenseStatistic {
    var value: Float
    var currency:String = Constants.currency
    
    init(_ value: Float) {
        self.value = value
    }
}

struct TimeStatistic {
    var value: Float
    var periodValue:Float
}
