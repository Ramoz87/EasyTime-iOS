//
//  AddExpenseViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let titleText = NSLocalizedString("Expenses", comment: "")
    static let buttonText = NSLocalizedString("Add Photo", comment: "")
    static let buttonCornerRadius: CGFloat = 4
    static let buttonBorderColor = UIColor(red: 109 / 255, green: 137 / 255, blue: 175 / 255, alpha: 1)
    static let buttonBorderDashPattern: [NSNumber] = [4, 4]
    static let buttonIconSpacing: CGFloat = 3
    static let textFieldCornerRadius: CGFloat = 4
    static let textFieldBorderWidth: CGFloat = 1
    static let buttonBottomPadding: CGFloat = 12
}

class AddExpenseViewController: BaseViewController<AddExpenseViewModel>, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var lblExpenseType: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnAddBottomConstraint: NSLayoutConstraint!

    lazy var imagePickerController: UIImagePickerController = {

        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = self
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.titleText
        self.lblExpenseType.text = self.viewModel.name
        self.lblCurrency.text = self.viewModel.measure

        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationsHandler(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)

        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = Constants.buttonBorderColor.cgColor
        borderLayer.lineDashPattern = Constants.buttonBorderDashPattern
        borderLayer.frame = self.btnAdd.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(rect: self.btnAdd.bounds).cgPath
        borderLayer.cornerRadius = Constants.buttonCornerRadius
        self.btnAdd.layer.addSublayer(borderLayer)
        self.btnAdd.alignVertical(spacing: Constants.buttonIconSpacing)
        self.btnAdd.setTitle(Constants.buttonText, for: .normal)

        let controller = NumberInputViewController()
        self.tfValue.inputViewController = controller
        self.tfValue.inputAccessoryView = UIView() // To hide IQKeyboardManager toolbar
        self.tfValue.layer.borderColor = UIColor.et_blueColor.cgColor
        self.tfValue.layer.borderWidth = Constants.textFieldBorderWidth
        self.tfValue.layer.cornerRadius = Constants.textFieldCornerRadius
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.tfValue.becomeFirstResponder()
    }

    //MARK: - Action handlers

    @IBAction func didTapAddButton(sender: Any) {

        self.present(self.imagePickerController, animated: true, completion: nil)
    }

    //MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        guard let value = self.tfValue.text, value.count > 0 else {
            return false
        }
        
        self.viewModel.value = value
        self.viewModel.save()
        if let vc = self.navigationController?.viewControllers[1] {
            self.navigationController?.popToViewController(vc, animated: true)
        }
        return true
    }

    //MARK: - Notifications handler

    @objc func notificationsHandler(notification: Notification) {

        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            var keyboardHeight = keyboardFrame.cgRectValue.height

            if let tabBarHeight = self.tabBarController?.tabBar.frame.height {

                keyboardHeight -= tabBarHeight
            }

            self.btnAddBottomConstraint.constant = keyboardHeight + Constants.buttonBottomPadding
        }
    }

    //MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            self.viewModel.photo = image
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: true, completion: nil)
    }

    //MARK: - Clean

    deinit {

        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
}
