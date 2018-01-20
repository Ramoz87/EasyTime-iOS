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
    private(set) var isSelected = false
    let material: ETMaterial
    private(set) var quantityString: String?

    var cell: AddMaterialsTableViewCell? {

        didSet {

            if let cell = self.cell {

                cell.delegate = self
                cell.tfQuantity.placeholder = String(describing: Int(self.material.stockQuantity))
                cell.tfQuantity.text = self.quantityString
                cell.tfQuantity.text = self.isSelected ? String(describing: Int(self.material.stockQuantity)) : nil
                cell.lblName.text = self.material.name
                cell.accessoryType = self.isSelected ? .checkmark : .none
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

    func addMaterialsTableViewCellDidSelect(cell: AddMaterialsTableViewCell) {

        self.isSelected = true
        cell.accessoryType = .checkmark
        cell.tfQuantity.text = String(describing: Int(self.material.stockQuantity))
    }

    func addMaterialsTableViewCellDidDeselect(cell: AddMaterialsTableViewCell) {

        self.isSelected = false
        cell.accessoryType = .none
    }
}
