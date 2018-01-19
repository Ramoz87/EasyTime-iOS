//
//  AddMaterialsTableViewCellController.swift
//  EasyTime
//
//  Created by Mobexs on 1/19/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

protocol AddMaterialsTableViewCellControllerDelegate: class {

    func inputViewController(for cell: AddMaterialsTableViewCell) -> UIInputViewController?
}

class AddMaterialsTableViewCellController: AddMaterialsTableViewCellDelegate {

    weak var delegate: AddMaterialsTableViewCellControllerDelegate?
    private let material: ETMaterial
    private var quantityString: String?

    var cell: AddMaterialsTableViewCell? {

        didSet {

            if let cell = self.cell {

                cell.delegate = self
                cell.tfQuantity.placeholder = String(describing: self.material.stockQuantity)
                cell.tfQuantity.text = self.quantityString
                cell.lblName.text = self.material.name
                if let controller = self.delegate?.inputViewController(for: cell) {

                    cell.tfQuantity.inputViewController = controller
                }
            }

        }
    }

    init(material: ETMaterial) {

        self.material = material
    }

    //MARK: - AddMaterialsTableViewCellDelegate

    func addMaterialsTableViewCellWillPrepareForReuse(cell: AddMaterialsTableViewCell) {

        cell.delegate = nil
        cell.lblName.text = nil
        cell.tfQuantity.text = nil
    }

    func addMaterialsTableViewCell(cell: AddMaterialsTableViewCell, didUpdateQuantityText text: String?) {

        self.quantityString = text
    }
}
