//
//  AppManager.swift
//  EasyTime
//
//  Created by Mobexs on 12/8/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let fileCustomers = "customer.csv"
    static let fileProjects = "projects.csv"
    static let fileOrders = "orders.csv"
    static let fileObjects = "objects.csv"
    static let fileTypes = "types.csv"
    static let fileUsers = "users.csv"
    static let fileMaterials = "materials.csv"
    static let lastSyncDate = "LastSyncDate"
}

class AppManager {
    
    static let sharedInstance = AppManager()
    let authenticator = Authenticator()
    let dataHelper = DataHelper()

    lazy var otherExpenseTypeId: String = {

        return "e8e0efb0-785a-4447-88a2-3d1de961eba4"
    }()

    var lastSyncDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: Constants.lastSyncDate) as? Date
        }
        set(newDate) {
            UserDefaults.standard.set(newDate, forKey: Constants.lastSyncDate)
        }
    }
    
    private var initialDataCounter: Int = 0
    private var initialDataError: Error?
    private var initialDataCompletion: ((Bool, Error?) -> Void)?
    
    func prepareInitialData(completion: @escaping (Bool, Error?) -> Void) {
        
        self.initialDataCompletion = completion
        
        DispatchQueue.global(qos: .utility).async {
            let csvFiles = [Customer.entityName : Bundle(for: type(of: self)).url(forResource: Constants.fileCustomers, withExtension: nil)!,
                            Project.entityName : Bundle(for: type(of: self)).url(forResource: Constants.fileProjects, withExtension: nil)!,
                            Order.entityName : Bundle(for: type(of: self)).url(forResource: Constants.fileOrders, withExtension: nil)!,
                            Object.entityName : Bundle(for: type(of: self)).url(forResource: Constants.fileObjects, withExtension: nil)!,
                            Type.entityName : Bundle(for: type(of: self)).url(forResource: Constants.fileTypes, withExtension: nil)!,
                            User.entityName : Bundle(for: type(of: self)).url(forResource: Constants.fileUsers, withExtension: nil)!,
                            Material.entityName : Bundle(for: type(of: self)).url(forResource: Constants.fileMaterials, withExtension: nil)!]
            
            let parser = CSVParser()
            parser.startIndex = 1
            parser.progress = { csvName, objects in
                self.initialDataCounter += 1
                self.dataHelper.saveInBackground(data: objects, completion: { (array, error) in
                    self.initialDataCounter -= 1
                    self.completePrepareData(error)
                })
            }
            
            do {
                for url in csvFiles {
                    try parser.parse(url: url.value, entity: url.key)
                }

                self.completePrepareData(nil)
            }
            catch {
                self.completePrepareData(error)
            }
        }
    }
    
    private func completePrepareData(_ error: Error?) {
        
        if (self.initialDataError==nil) {
            self.initialDataError = error
        }
        
        if (self.initialDataCounter == 0) {
            DispatchQueue.main.async {
                self.initialDataCompletion?(self.initialDataError == nil, self.initialDataError)
            }
        }
    }
}
