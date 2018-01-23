//
//  ProjectInfoSectionView.swift
//  EasyTime
//
//  Created by Mobexs on 1/20/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

protocol ProjectInfoSectionViewDelegate: class {

    func didExpandProjectInfoSectionView(view: ProjectInfoSectionView)
    func didCollapseProjectInfoSectionView(view: ProjectInfoSectionView)
}

class ProjectInfoSectionView: UIView {

    static let sectionHeight: CGFloat = 55

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var imgAccessory: UIImageView!
    @IBOutlet weak var button: InputButton!

    weak var delegate: ProjectInfoSectionViewDelegate?
    var sectionIndex: Int = 0
    var isExpanded: Bool = false {

        didSet {

            self.imgAccessory.isHighlighted = self.isExpanded
        }
    }

    static func createFromXIB() -> ProjectInfoSectionView {

        return Bundle.main.loadNibNamed("ProjectInfoSectionView", owner: nil, options: nil)!.first as! ProjectInfoSectionView
    }

    //MARK: - Actions handlers

    @IBAction func didClick(sender: Any) {

        guard let delegate = self.delegate else { return }

        self.isExpanded = !self.isExpanded

        if self.isExpanded == true {

            delegate.didExpandProjectInfoSectionView(view: self)
        }
        else {

            delegate.didCollapseProjectInfoSectionView(view: self)
        }
    }
}
