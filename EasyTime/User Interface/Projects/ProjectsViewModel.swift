//
//  ProjectsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 12/12/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import CoreData

class ProjectsViewModel: BaseViewModel {

    required init() {

        /*
        let context = AppManager.sharedInstance.dataHelper.mainContext

        for i in 1...10 {

            let job = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! Project
            job.jobId = "Project \(i)"
        }

        for i in 1...10 {

            let job = NSEntityDescription.insertNewObject(forEntityName: "Object", into: context) as! Object
            job.jobId = "Object \(i)"
        }

        do { try context.save() } catch (let error){ print(error) }
         */
        //TODO: REMOVE
    }

    lazy var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult> = {

        let controller = AppManager.sharedInstance.dataHelper.fetchedResultsController(entityName: "Job", sort: [])
        return controller
    }()
}
