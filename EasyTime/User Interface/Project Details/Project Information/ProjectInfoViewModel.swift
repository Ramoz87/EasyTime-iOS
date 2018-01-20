//
//  ProjectInfoViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/20/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

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

struct ProjectInfoSectionInfo {

    var isSelected = false
    private let job: ETJob
    private let type: ProjectInfoSectionType

    init(type: ProjectInfoSectionType, job: ETJob) {

        self.type = type
        self.job = job
    }

    func sectionHeight() -> CGFloat {

        switch self.type {

            case .customer,
                 .instructions,
                 .status:
                return 55
            case .objects:
                if let project = self.job as? ETProject,
                    let objects = project.objects,
                    objects.count > 0 {

                    return 55
                }
                return 0
            case .employees:
                return 55
        }
    }

    func numberOfRows() -> Int {

        switch self.type {

            case .customer:
                return 3
            case .instructions:
                return 3
            case .status:
                return 1
            case .objects:
                if let project = self.job as? ETProject,
                    let objects = project.objects,
                    objects.count > 0 {

                    return 10
                }
                return 0
            case .employees:
                return 10
        }
    }

    func heightForRow(row: Int) -> CGFloat {

        return self.isSelected ? 50 : 0
    }

    func titleForHeader() -> String? {

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
}

class ProjectInfoViewModel: BaseViewModel {

    private let job: ETJob
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

    func numberOfSections() -> Int {

        return ProjectInfoSectionType.count()
    }

    func numberOfRowsInSection(section: Int) -> Int {

        let section = self.sections[section]
        return section.numberOfRows()
    }

    func titleForHeaderInSection(section: Int) -> String? {

        let section = self.sections[section]
        return section.titleForHeader()
        
    }

    func heightForRow(at indexPath: IndexPath) -> CGFloat {

        let section = self.sections[indexPath.section]
        return section.heightForRow(row: indexPath.row)
    }
}
