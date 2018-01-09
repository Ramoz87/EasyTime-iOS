//
//  TabBarViewController.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 07/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var ctrl: UIViewController = ProjectsViewController()
        ctrl.title = NSLocalizedString("Projects", comment: "")
        let ctrlTab1 = UINavigationController(rootViewController: ctrl)
        ctrlTab1.tabBarItem = UITabBarItem(title: ctrl.title, image: UIImage(named: "projectsIcon"), selectedImage: nil)

        ctrl = MaterialsViewController()
        ctrl.title = NSLocalizedString("Materials", comment: "")
        let ctrlTab2 = UINavigationController(rootViewController: ctrl)
        ctrlTab2.tabBarItem = UITabBarItem(title: ctrl.title, image: UIImage(named: "materialsIcon"), selectedImage: nil)

        ctrl = ClientsViewController()
        ctrl.title = NSLocalizedString("Clients", comment: "")
        let ctrlTab3 = UINavigationController(rootViewController: ctrl)
        ctrlTab3.tabBarItem = UITabBarItem(title:  ctrl.title, image: UIImage(named: "clientsIcon"), selectedImage: nil)

        ctrl = SettingsViewController()
        ctrl.title = NSLocalizedString("Settings", comment: "")
        let ctrlTab4 = UINavigationController(rootViewController: ctrl)
        ctrlTab4.tabBarItem = UITabBarItem(title:  ctrl.title, image: UIImage(named: "settingsIcon"), selectedImage: nil)

        self.viewControllers = [ctrlTab1, ctrlTab2, ctrlTab3, ctrlTab4]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
