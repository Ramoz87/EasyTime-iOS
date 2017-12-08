//
//  BaseViewController.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 07/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    private let viewModel: BaseViewModel
    
    init(model: BaseViewModel) {
        self.viewModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        self.viewModel = BaseViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.viewModel.save()
    }

}
