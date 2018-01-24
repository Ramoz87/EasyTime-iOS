//
//  MaterialsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 12/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {
    
    static let sortDescriptor = "name"
    static let unitPredicate = "type = 'UNIT_TYPE'"
    static let materialPredicate = "inStock = true"
}

class StockMaterialsViewModel: BaseViewModel {

    private var materails = Array<ETMaterial>()
    
    private lazy var fetchResultsController: NSFetchedResultsController<Material> = {
        
        let fetchedResultsController: NSFetchedResultsController<Material> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                           predicate: NSPredicate(format: Constants.materialPredicate))
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private lazy var materialUnits: [Type]? = {
        
        do {
            let units: [Type]? = try AppManager.sharedInstance.dataHelper.fetchData(predicate: NSPredicate(format: Constants.unitPredicate))
            return units
        }
        catch {
            return nil
        }
    }()
    
    var hasData: Bool {
        get {
            return self.numberOfRowsInSection(section: 0) > 0
        }
    }
    
    func remove(at indexPath: IndexPath) {
        let item = self.fetchResultsController.object(at: indexPath)
        item.inStock = false
        item.stockQuantity = 0
        
        self.materails = self.materails.filter {$0.materialId != item.materialId}
    }
    
    func resetCachedData(){
        self.materails.removeAll()
    }
    
    subscript(indexPath: IndexPath) -> ETMaterial {
        
        let fetchedItem = self.fetchResultsController.object(at: indexPath)
        
        guard let material = materails.filter({$0.materialId == fetchedItem.materialId}).first else {
            let newMaterial = ETMaterial(material:fetchedItem)
            if let unit = self.materialUnits?.filter({$0.typeId == fetchedItem.unitId}).first {
                newMaterial.unit = unit.name
            }
            
            materails.append(newMaterial)
            return newMaterial
        }
        
        return material
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        guard let count = self.fetchResultsController.sections?[section].numberOfObjects else { return 0 }
        return count
    }
    
    func updateResults() {
                
        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
    
    override func save() {
        
        guard let materials = self.fetchResultsController.fetchedObjects else {
            return
        }

        for item in materials {
            if let material = self.materails.filter ({$0.materialId == item.materialId}).first {
                item.stockQuantity = material.stockQuantity
            }
        }

        super.save()
    }
    
}
