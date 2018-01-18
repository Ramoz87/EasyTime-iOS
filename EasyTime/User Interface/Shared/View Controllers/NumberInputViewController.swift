//
//  NumberInputViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/11/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let nextText = NSLocalizedString("Next", comment: "")
}

class NumberInputViewController: UIInputViewController {

    @IBOutlet weak var btnNext: UIButton!

    init() {

        super.init(nibName: "NumberInputViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnNext.setTitle(Constants.nextText, for: .normal)
        self.btnNext.alignVertical()

        self.view?.translatesAutoresizingMaskIntoConstraints = false
    }

    //MAKR: - Action handlers

    @IBAction func didTapNumber(sender: UIButton) {

        if let numberString = sender.title(for: .normal) {

            self.textDocumentProxy.insertText(numberString)
        }
    }

    @IBAction func didTapBack(sender: UIButton) {

        self.textDocumentProxy.deleteBackward()
    }

    @IBAction func didTapNext(sender: UIButton) {

        self.textDocumentProxy.insertText("\n")
    }
}
