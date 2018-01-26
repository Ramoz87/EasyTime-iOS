//
//  ETProject.swift
//  EasyTime
//
//  Created by Mobexs on 12/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ETProject: ETJob {

    var dateEnd: NSDate?
    var dateStart: NSDate?
    
    override var objects: [String]? {
        get {
            let objects = self.project.objects?.components(separatedBy: ",").filter {$0.count > 0}
            return objects
        }
    }
    
    lazy var customer: ETCustomer? = {

        if let customer = self.project.customer {

            return ETCustomer(customer: customer)
        }
        return nil
    }()

    private var project: Project

    init(project: Project) {

        self.project = project
        super.init(job: project)

        self.dateEnd = project.dateEnd
        self.dateStart = project.dateStart
    }
}
