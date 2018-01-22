//
//  ProjectInfoViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/20/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ProjectInfoViewModel: BaseViewModel {

    let job: ETJob
    private let sections: [ProjectInfoSectionInfo]

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
            self.objects = ["Name Surname", "Address", "10 am"]
        case .instructions:
            self.objects = ["Name Surname", "Address", "10 am"]
        case .status:
            self.objects = []
        case .objects:
            self.objects = ["Object 1", "Object 2"]
        case .employees:
            self.objects = ["Employee 1", "Employee 2"]
        }
    }

    func numberOfObjects() -> Int {

        return self.objects.count
    }

    func sectionTitle() -> String? {

        switch self.type {

        case .customer:
            return "CUSTOMER"
        case .instructions:
            return "INSTRUCTIONS"
        case .status:
            return "STATUS"
        case .objects:
            return "OBJECTS"
        case .employees:
            return "EMPLOYEES"
        }
    }

    func titleForObject(at index: Int) -> String? {

        return self.objects[index]
    }
}
