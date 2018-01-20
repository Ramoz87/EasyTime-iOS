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
    var fileUrl: URL?

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
    
    func remove() {
        
        guard let expense = self.expense  else {
            return
        }
        
        AppManager.sharedInstance.dataHelper.delete(data: [expense]) { (error) in
            
        }
    }
    
    func saveImage(image: UIImage)
    {
        do {
            let fileManager = FileManager.default
            let docDir = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let folderPath = docDir.appendingPathComponent(AppConstants.expenseFolder).path
            let fileName = String(format:"%@.png", self.expenseId!)
            
            if !fileManager.fileExists(atPath: folderPath) {
                try fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            }
            
            let imagePath = NSURL(fileURLWithPath: folderPath).appendingPathComponent(fileName)
            let imageData = UIImagePNGRepresentation(image)!
            try imageData.write(to: imagePath!)
            self.fileUrl = imagePath
        }
        catch { }
    }
}
