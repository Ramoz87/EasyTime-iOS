//
//  AddMaterialsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/19/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {

    static let sortDescriptor = "name"
    static let searchPredicate = "name CONTAINS[cd] %@"
    static let unitPredicate = "type = 'UNIT_TYPE'"
}

class AddMaterialsViewModel: BaseViewModel {

    private let job: ETJob
    
    private var selectedMaterails = Set<ETMaterial>()
    private var materails = Array<ETMaterial>()
    
    private lazy var fetchResultsController: NSFetchedResultsController<Material> = {

        let fetchedResultsController: NSFetchedResultsController<Material> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor])
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
    
    var hasMaterialsToAdd: Bool {
        get {
            let materials = self.selectedMaterails.filter { $0.quantity > 0}
            return materials.count > 0
        }
    }

    init(job: ETJob) {

        self.job = job
        super.init()
        self.updateSearchResults()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(indexPath: IndexPath) -> ETMaterial {

        let fetchedItem = self.fetchResultsController.object(at: indexPath)
     
        guard let material = materails.filter({$0.materialId == fetchedItem.materialId}).first else {
            let newMaterial = ETMaterial(material:fetchedItem)
            materails.append(newMaterial)
            return newMaterial
        }
        
        return material
    }
    
    func select(at indexPath: IndexPath) -> Int {
        self.selectedMaterails.insert(self[indexPath])
        
        return self.selectedMaterails.count
    }
    
    func deselect(at indexPath: IndexPath) -> Int {
        self.selectedMaterails.remove(self[indexPath])
        
        return self.selectedMaterails.count
    }

    func numberOfRowsInSection(section: Int) -> Int {

        guard let count = self.fetchResultsController.sections?[section].numberOfObjects else { return 0 }
        return count
    }

    func updateSearchResults(text: String? = nil) {

        var predicate: NSPredicate?
        if let text = text, text.count > 0 {

            predicate = NSPredicate(format: Constants.searchPredicate, text)
        }

        self.fetchResultsController.fetchRequest.predicate = predicate

        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }

    override func save() {

        for material in self.selectedMaterails {

            if material.quantity > 0  {

                let expense = ETExpense()
                expense.materialId = material.materialId
                expense.name = material.name
                expense.type = .material
                expense.value = material.quantity
                if let unit = self.materialUnits?.filter({$0.typeId == material.unitId}).first {
                    expense.unit = unit.name
                }
            
                self.job.addExpense(expense: expense)
            }
        }
        
        super.save()
    }
}

