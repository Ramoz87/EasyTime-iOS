//
//  AddMaterialsTableViewCell.swift
//  EasyTime
//
//  Created by Mobexs on 1/19/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    
    static let textFieldCornerRadius: CGFloat = 4
    static let textFieldBorderWidth: CGFloat = 1
}

protocol AddMaterialsTableViewCellDelegate: class {

    func addMaterialsTableViewCellWillPrepareForReuse(cell: AddMaterialsTableViewCell)
    func addMaterialsTableViewCell(cell: AddMaterialsTableViewCell, didUpdateQuantityText text: String?)
    func addMaterialsTableViewCellDidSelect(cell: AddMaterialsTableViewCell)
    func addMaterialsTableViewCellDidDeselect(cell: AddMaterialsTableViewCell)
}

class AddMaterialsTableViewCell: UITableViewCell, UITextFieldDelegate {

    static let reuseIdentifier = "AddMaterialsTableViewCellReuseIdentifier"
    static let cellName = "AddMaterialsTableViewCell"

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tfQuantity: UITextField!

    weak var delegate: AddMaterialsTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.tfQuantity.inputAccessoryView = UIView() // To hide IQKeyboardManager toolbar
        self.tfQuantity.layer.borderColor = UIColor.et_blueColor.cgColor
        self.tfQuantity.layer.borderWidth = Constants.textFieldBorderWidth
        self.tfQuantity.layer.cornerRadius = Constants.textFieldCornerRadius
    }

    override func prepareForReuse() {

        self.delegate?.addMaterialsTableViewCellWillPrepareForReuse(cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)

        if self.isSelected == true {

            self.delegate?.addMaterialsTableViewCellDidSelect(cell: self)
        }
        else {

            self.delegate?.addMaterialsTableViewCellDidDeselect(cell: self)
        }
    }

    //MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        var updatedText: String?
        if let text = textField.text as NSString? {

            updatedText = text.replacingCharacters(in: range, with: string)
        }
        self.delegate?.addMaterialsTableViewCell(cell: self, didUpdateQuantityText: updatedText)
        
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        textField.text = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
}
