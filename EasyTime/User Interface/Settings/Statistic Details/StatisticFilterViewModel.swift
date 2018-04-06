//
//  StatisticFilterViewModel.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 03/04/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let periodDay = 30
    static let periodWeek = 4
    static let periodMonth = 12
}

class StatisticFilterViewModel: BaseViewModel {

    var dataSource: [StatisticFilterObject] = []
    
    var selectedPeriod: StatPeriod = .day
    var selectedIndexDay: Int = 0
    var selectedIndexMonth: Int = -1
    var selectedIndexWeek: Int = -1
    
    var selectedIndex: Int {
        get {
            switch self.selectedPeriod {
            case .day: return selectedIndexDay
            case .week: return selectedIndexWeek
            case .month: return selectedIndexMonth
            }
        }
        set {
            switch self.selectedPeriod {
            case .day:
                selectedIndexDay = newValue
                selectedIndexWeek = -1
                selectedIndexMonth = -1
                break
            case .week:
                selectedIndexWeek = newValue
                selectedIndexDay = -1
                selectedIndexMonth = -1
                break
            case .month:
                selectedIndexMonth = newValue
                selectedIndexDay = -1
                selectedIndexWeek = -1
                break
            }
        }
    }
    
    subscript(index: Int) -> StatisticFilterObject? {
        guard index < self.dataSource.count else { return nil }
        
        return self.dataSource[index]
    }
    
    func numberOfItems() -> Int {
        return self.dataSource.count
    }
    
    func updateForPeriod(period: StatPeriod) {
        
        self.selectedPeriod = period
        
        switch period {
        case .day:
            self.prepareDailyDataSource()
            
            break
        case .week:
            self.prepareWeeklyDataSource()
            
            break
        case .month:
            
            self.prepareMonthlyDataSource()
            break
        }
    }
        
    private func prepareDailyDataSource() {
        self.dataSource.removeAll()
        
        var day = Date()
        
        for index in 0..<Constants.periodDay {
            let object = StatisticFilterObject(startDate: day.startOfDay, endDate: day.endOfDay)
            object.title = day.toString("dd MMM")
            object.header = day.toString("EE")
            object.selected = (index == self.selectedIndex)
            dataSource.append(object)
            day = Calendar.current.date(byAdding: .day, value: -1, to: day)!
        }
    }
    
    private func prepareWeeklyDataSource() {
        self.dataSource.removeAll()
        
        var day = Date()
        
        for index in 0..<Constants.periodWeek {
            let start = day.startOfWeek
            let end = day.endOfWeek
            
            let object = StatisticFilterObject(startDate: start, endDate: end)
            object.title = String(format: "%@-%@", start.toString("dd"), end.toString("dd"))
            if Calendar.current.component(.month, from: start) == Calendar.current.component(.month, from: end)
            {
                object.header = start.toString("MMMM")
            }
            else
            {
                object.header = String(format: "%@-%@", start.toString("MMM"), end.toString("MMM"))
            }
            object.selected = (index == self.selectedIndex)
            dataSource.append(object)
            
            day = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: start)!
        }
    }
    
    private func prepareMonthlyDataSource() {
        self.dataSource.removeAll()
        
        var day = Date()
        
        for index in 0..<Constants.periodMonth {
            let start = day.startOfMonth
            let end = day.endOfMonth
            
            let object = StatisticFilterObject(startDate: start, endDate: end)
            object.header = start.toString("MMMM")
            object.title = start.toString("YYYY")
            object.selected = (index == self.selectedIndex)
            dataSource.append(object)
            
            day = Calendar.current.date(byAdding: .month, value: -1, to: start)!
        }
    }
}

class StatisticFilterObject {
    var title: String?
    var header: String?
    var start: Date
    var end: Date
    
    var selected: Bool = false
    
    init(startDate: Date, endDate: Date) {
        self.start = startDate
        self.end = endDate
    }
}
