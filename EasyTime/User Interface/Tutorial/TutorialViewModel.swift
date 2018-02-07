//
//  TutorialViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 2/7/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

struct TutoriaItem {

    let title: String
    let description: String
    let imageName: String
}

class TutorialViewModel: BaseViewModel {

    private let items: [TutoriaItem]

    required init() {

        self.items = [TutoriaItem(title: NSLocalizedString("Main page", comment: ""), description: NSLocalizedString("You can see all your projects and choose what you need", comment: ""), imageName: "jobEmployeesIcon"),
                      TutoriaItem(title: NSLocalizedString("Stock", comment: ""), description: NSLocalizedString("Manage your storage in a few seconds", comment: ""), imageName: "jobEmployeesIcon"),
                      TutoriaItem(title: NSLocalizedString("Materials", comment: ""), description: NSLocalizedString("Add materials to your project\nYou can’t add more than in your stock", comment: ""), imageName: "jobEmployeesIcon"),
                      TutoriaItem(title: NSLocalizedString("", comment: ""), description: NSLocalizedString("", comment: ""), imageName: "jobEmployeesIcon")]
        super.init()
    }

    subscript(indexPath: IndexPath) -> TutoriaItem {

        return self.items[indexPath.item]
    }

    func numberOfItemsInSection(section: Int) -> Int {

        return self.items.count
    }
}
