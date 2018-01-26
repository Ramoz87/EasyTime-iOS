//
//  InvoiceViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/25/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let buttonCornerRadius: CGFloat = 4
    static let buttonBorderWidth: CGFloat = 1 / UIScreen.main.scale
}

class InvoiceViewController: BaseViewController<InvoiceViewModel>, UITableViewDataSource, UITableViewDelegate, CollectionViewUpdateDelegate, SignatureViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var btnSign: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.viewModel.job.number
        self.tableHeaderView.text = self.viewModel.customer?.companyName

        self.tableView.register(UINib.init(nibName: InvoiceTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: InvoiceTableViewCell.reuseIdentifier)
        self.tableView.tableHeaderView = self.tableHeaderView
        self.viewModel.collectionViewUpdateDelegate = self

        for button in self.buttons {

            button.alignVertical()
            button.layer.borderWidth = Constants.buttonBorderWidth
            button.layer.cornerRadius = Constants.buttonCornerRadius
            button.layer.borderColor = UIColor.et_borderColor.cgColor
        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "discountIcon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.didTapDiscountButton(sender:)))
    }

    //MARK: - Action handlers

    @objc func didTapDiscountButton(sender: Any) {

    }

    @IBAction func didTapSignButton(sender: Any) {

        let controller = SignatureViewController()
        controller.delegate = self
        controller.title = self.viewModel.job.number
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func didTapSaveButton(sender: Any) {

    }

    @IBAction func didTapSendButton(sender: Any) {

    }

    //MARK: - SignatureViewControllerDelegate

    func signatureViewController(controller: SignatureViewController, didFinishWithImage image: UIImage?, author type: SignatureAuthorType) {

        controller.navigationController?.popViewController(animated: true)

        if let image = image {

            self.btnSign.isEnabled = false
            self.viewModel.updateSignature(image: image, author: type)
        }
    }

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: InvoiceTableViewCell.reuseIdentifier, for: indexPath) as! InvoiceTableViewCell

        let expense = self.viewModel[indexPath]
        cell.textLabel?.text = expense.name
        cell.detailTextLabel?.text = "\(expense.value)"

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return self.viewModel.titleForHeaderInSection(section: section)
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }

    //MARK: - CollectionViewUpdateDelegate

    func didChangeObject(at indexPath: IndexPath?, for type: CollectionViewChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if  let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if  let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if  let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if  let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if  let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }

    func didChangeSection(at sectionIndex: Int, for type: CollectionViewChangeType) {

        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }

    func willChangeContent() {

        self.tableView.beginUpdates()
    }

    func didChangeContent() {

        self.tableView.endUpdates()
    }

    func didChangeDataSet() {
        self.tableView.reloadData()
    }
}
