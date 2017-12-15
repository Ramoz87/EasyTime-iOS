//
//  CSVParser.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 12/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class CSVParser: NSObject, ParserDelegate {

    public var startIndex: Int = 0
    public var batchSize: Int = 500
    public var progress: ((_ csvName: String, _ objects: [DataObject]) -> Void)?
    
    private var parsedObjects = [CSVObject]()
    private var currentObject: CSVObject?
    private var entityName: String?


    public func parse(url fileUrl: URL) throws {
        let parser = CSV.Parser(url: fileUrl, configuration: CSV.Configuration(delimiter: ","))!
        parser.descrtiption = fileUrl.lastPathComponent
        parser.delegate = self
        try parser.parse()
    }
    
    public func parse(url fileUrl: URL, entity name: String) throws {
        self.entityName = name
        try self.parse(url: fileUrl)
    }
    
    private func showProgress(for parser: CSV.Parser) {
        DispatchQueue.main.sync {
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
        if(index >= startIndex)
        {
            currentObject = CSVObject()
            if let name = self.entityName {
                currentObject!.entityName = name
            }
        }
    }
    
    func parser(_ parser: CSV.Parser, didEndLineAt index: UInt) {
        if index >= startIndex, let object = currentObject {
            self.parsedObjects.append(object)
            if(self.parsedObjects.count == self.batchSize) {
                self.showProgress(for: parser)
            }
        }
    }
    
    func parser(_ parser: CSV.Parser, didReadFieldAt index: UInt, value: String) {
            currentObject?.data.append(value)
    }
}

struct CSVObject: DataObject {
    var entityName: String = ""
    var data: Array = [String]()
    
    subscript(index: Int) -> String? {
        get {
            if(index < data.count) { return data[index] }
            else { return nil }
        }
    }
}
