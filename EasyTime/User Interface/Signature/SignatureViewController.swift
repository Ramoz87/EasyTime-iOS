//
//  SignatureViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/26/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

enum SignatureAuthorType: Int {

    case client
    case me
}

fileprivate struct Constants {

    static let signButtonTitle = NSLocalizedString("SIGN", comment: "")
    static let signButtonCornerRadius: CGFloat = 4
    static let signatureAuthroTitles = [
        NSLocalizedString("Client", comment: ""),
        NSLocalizedString("Me", comment: "")
    ]
}

protocol SignatureViewControllerDelegate: class {

    func signatureViewController(controller: SignatureViewController, didFinishWithImage image: UIImage?, author type: SignatureAuthorType)
}

class SignatureViewController: BaseViewController<BaseViewModel> {

    @IBOutlet weak var vSignature: EPSignatureView!
    @IBOutlet weak var scAuthor: UISegmentedControl!
    @IBOutlet weak var btnSign: UIButton!

    weak var delegate: SignatureViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnSign.layer.cornerRadius = Constants.signButtonCornerRadius
        self.btnSign.setTitle(Constants.signButtonTitle, for: .normal)
        self.btnSign.backgroundColor = UIColor.et_blueColor
        self.scAuthor.tintColor = UIColor.et_blueColor

        self.scAuthor.setTitle(Constants.signatureAuthroTitles[0], forSegmentAt: 0)
        self.scAuthor.setTitle(Constants.signatureAuthroTitles[1], forSegmentAt: 1)
    }

    //MARK: - Action handlers

    @IBAction func didTapSignButton(sender: Any) {

        let type = SignatureAuthorType(rawValue: self.scAuthor.selectedSegmentIndex)!
        self.delegate?.signatureViewController(controller: self, didFinishWithImage: self.vSignature.getSignatureAsImage(), author: type)
    }
}
