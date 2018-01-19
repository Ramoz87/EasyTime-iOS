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
}

class AddMaterialsViewModel: BaseViewModel {

    private let job: ETJob
    private var cellControllers: [String: AddMaterialsTableViewCellController] = [:]
    private lazy var fetchResultsController: NSFetchedResultsController<Material> = {

        let fetchedResultsController: NSFetchedResultsController<Material> = AppManager.sharedInstance.dataHelper.fetchedResultsController(entityName: Material.entityName,
                                                                                                                                          sort: [Constants.sortDescriptor],
                                                                                                                                          sectionNameKeyPath:nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    init(job: ETJob) {

        self.job = job
        super.init()
        self.updateSearchResults()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(indexPath: IndexPath) -> ETMaterial {

        let material = self.fetchResultsController.object(at: indexPath)
        return ETMaterial(material: material)
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

    func dequeueTableViewCellController(for material: ETMaterial) -> AddMaterialsTableViewCellController {

        guard let cellController = self.cellControllers[material.materialId!] else {

            let cellController = AddMaterialsTableViewCellController(material: material)
            self.cellControllers[material.materialId!] = cellController
            return cellController
        }
        return cellController
    }
}
