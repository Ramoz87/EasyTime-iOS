//
//  ProjectInfoViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/20/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let statusesPredicate = "type = %@"
    static let sectionTitleCustomer = NSLocalizedString("CUSTOMER", comment: "")
    static let sectionTitleInstructions = NSLocalizedString("INSTRUCTIONS", comment: "")
    static let sectionTitleStatus = NSLocalizedString("STATUS", comment: "")
    static let sectionTitleObjects = NSLocalizedString("OBJECTS", comment: "")
    static let sectionTitleEmployees = NSLocalizedString("EMPLOYEES", comment: "")
}

class ProjectInfoViewModel: BaseViewModel {

    private let sections: [ProjectInfoSectionInfo]
    private(set) var photos: [UIImage] = []

    let job: ETJob
    let statuses: [ETType]
    lazy var customer: ETCustomer? = {

        do {
            let predicate = NSPredicate(format: "customerId = %@", self.job.customerId!)
            if let managedCustomer: Customer = try AppManager.sharedInstance.dataHelper.fetchData(predicate: predicate)?.first {

                return ETCustomer(customer: managedCustomer)
            }
            return nil
        }
        catch { return nil }
    }()

    init(job: ETJob) {

        self.job = job

        var sections: [ProjectInfoSectionInfo] = []
        for i in 0...ProjectInfoSectionType.count() - 1 {

            if let type = ProjectInfoSectionType(rawValue: i) {

                let section = ProjectInfoSectionInfo(type: type, job: job)
                sections.append(section)
            }
        }
        self.sections = sections

        do {

            let predicate = NSPredicate(format: Constants.statusesPredicate, "STATUS")
            let managedStatuses: Array<Type>? = try AppManager.sharedInstance.dataHelper.fetchData(predicate: predicate)
            if let statuses = managedStatuses?.map({ type -> ETType in
                return ETType(type: type)
            }) {
                self.statuses = statuses
            }
            else {
                self.statuses = []
            }
        }
        catch {

            self.statuses = []
        }

        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(index: Int) -> ProjectInfoSectionInfo {

        return self.sections[index]
    }

    func numberOfSections() -> Int {

        return ProjectInfoSectionType.count()
    }

    func updateStatus(newStatus: ETType) {

        //TODO: Save new status
        self.job.statusId = newStatus.typeId
    }

    func addPhoto(photo: UIImage) {

        self.photos.append(photo)
    }
}

enum ProjectInfoSectionType: Int {

    case customer = 0
    case status
    case instructions
    case objects
    case employees

    static func count() -> Int {

        return 5
    }
}

class ProjectInfoSectionInfo {

    var isExpanded = false
    var isHidden: Bool {

        get {

            switch self.type {

            case .customer,
                 .instructions,
                 .status:
                return false
            case .objects:
                return self.numberOfObjects() == 0
            case .employees:
                return self.numberOfObjects() == 0
            }
        }
    }
    let job: ETJob
    let type: ProjectInfoSectionType
    private let objects: [String]

    init(type: ProjectInfoSectionType, job: ETJob) {

        self.job = job
        self.type = type

        switch type {

        case .customer:
            self.objects = []
        case .instructions:
            self.objects = ["Name Surname", "Address", "10 am"] //TODO: Real life data
        case .status:
            self.objects = []
        case .objects:
            self.objects = ["Object 1", "Object 2"] //TODO: Real life data
        case .employees:
            self.objects = ["Employee 1", "Employee 2"] //TODO: Real life data
        }
    }

    func numberOfObjects() -> Int {

        return self.objects.count
    }

    func sectionTitle() -> String? {

        switch self.type {

        case .customer:
            return Constants.sectionTitleCustomer
        case .instructions:
            return Constants.sectionTitleInstructions
        case .status:
            return Constants.sectionTitleStatus
        case .objects:
            return Constants.sectionTitleObjects
        case .employees:
            return Constants.sectionTitleEmployees
        }
    }

    func titleForObject(at index: Int) -> String? {

        return self.objects[index]
    }
}
