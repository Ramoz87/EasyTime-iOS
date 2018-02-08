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

        self.items = [TutoriaItem(title: NSLocalizedString("Task list", comment: ""),
                                  description: NSLocalizedString("Manage your projects, orders, objects in one place", comment: ""),
                                  imageName: "tutorial_1_Icon"),
                      TutoriaItem(title: NSLocalizedString("Stock", comment: ""),
                                  description: NSLocalizedString("Manage your materials in stock", comment: ""),
                                  imageName: "tutorial_2_Icon"),
                      TutoriaItem(title: NSLocalizedString("Materials", comment: ""),
                                  description: NSLocalizedString("Add materials to your project\nYou can’t add more than in your stock", comment: ""),
                                  imageName: "tutorial_3_Icon"),
                      TutoriaItem(title: NSLocalizedString("Clients", comment: ""),
                                  description: NSLocalizedString("All actual info about your clients", comment: ""),
                                  imageName: "tutorial_4_Icon"),
                      TutoriaItem(title: NSLocalizedString("Project’s information", comment: ""),
                                  description: NSLocalizedString("All actual info about your project:\nstatus, instructions, client etc", comment: ""),
                                  imageName: "tutorial_5_Icon"),
                      TutoriaItem(title: NSLocalizedString("Project’s activity", comment: ""),
                                  description: NSLocalizedString("Add your activities", comment: ""),
                                  imageName: "tutorial_6_Icon"),
                      TutoriaItem(title: NSLocalizedString("Invoice", comment: ""),
                                  description: NSLocalizedString("Work with invoice", comment: ""),
                                  imageName: "tutorial_7_Icon")]
        super.init()
    }

    subscript(indexPath: IndexPath) -> TutoriaItem {

        return self.items[indexPath.item]
    }

    func numberOfItemsInSection(section: Int) -> Int {

        return self.items.count
    }
}
