//
//  ProjectDetailsViewController.swift
//  EasyTime
//
//  Created by Sergei Kvasov on 1/5/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ProjectDetailsViewController: BaseViewController<BaseViewModel>, TabViewDelegate {

    @IBOutlet weak var tabView: TabView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabView.delegate = self
        self.tabView.selectItem(at: 1)
    }
    
    //MARK: - TabViewDelegate
    
    func numberOfItemsForTabView(tabView: TabView) -> Int {
    
        return 3
    }
    
    func tabView(_ tabView: TabView, titleForItemAtIndex index: Int) -> String? {
        
        return "Hello"
    }
    
    func tabView(_ tabView: TabView, didSelectItemAtIndex index: Int) {
        
        print(index)
    }
}
