//
//  CSVParser.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 12/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let fileType = "csv"
    static let fileCustomers = "customer.csv"
    static let entityCustomer = "Customer"
}

class CSVParser: NSObject, ParserDelegate {

    private var parsedObjects = [CSVObject]()
    private var currentObject: CSVObject?
    
    var progress: ((_ csvName: String, _ objects: [DataObject]) -> Void)?
    
    func parseInitialData(completion: ((_ success: Bool) -> Void)?) {
        DispatchQueue.global(qos: .utility).async {
            do {
                try self.parse(url: Bundle(for: type(of: self)).url(forResource: Constants.fileCustomers, withExtension: nil)!)
                
                DispatchQueue.main.async {
                    completion?(true)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion?(false)
                }
            }
        }
    }
    
    private func parse(url fileUrl: URL) throws {
            let parser = CSV.Parser(url: fileUrl, configuration: CSV.Configuration(delimiter: ","))!
            parser.descrtiption = fileUrl.lastPathComponent
            parser.delegate = self
            try parser.parse()
    }
    
    private func showProgress(for parser: CSV.Parser) {
        DispatchQueue.main.async {
            self.progress?(parser.descrtiption, self.parsedObjects)
            self.parsedObjects.removeAll()
        }
    }
    
    func parserDidBeginDocument(_ parser: CSV.Parser) {
        currentObject = nil
    }
    
    func parserDidEndDocument(_ parser: CSV.Parser) {
        self.showProgress(for: parser)
    }
    
    func parser(_ parser: CSV.Parser, didBeginLineAt index: UInt) {
        if(index > 0)
        {
            switch parser.descrtiption {
            case Constants.fileCustomers:
                currentObject = CSVObject(entityName: Constants.entityCustomer)
            default:
                currentObject = nil
            }
        }
    }
    
    func parser(_ parser: CSV.Parser, didEndLineAt index: UInt) {
        if let object = currentObject {
            self.parsedObjects.append(object)
        }
    }
    
    func parser(_ parser: CSV.Parser, didReadFieldAt index: UInt, value: String) {
        currentObject?.data.append(value)
    }
}

struct CSVObject: DataObject {
    var entityName: String
    var data: Array = [String]()
    
    init(entityName name: String) {
        self.entityName = name
    }
}
