//
//  AppDelegate.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 04/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureScreens();
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    // MARK: - Private
    func configureScreens() {
        UINavigationBar.appearance().barTintColor = UIColor.navigationColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]

        let rootController = ETTabBarViewController()
        
        var ctrl: UIViewController = ETProjectsViewController()
        ctrl.title = NSLocalizedString("Projects", comment: "")
        let ctrlTab1 = UINavigationController(rootViewController: ctrl)
        ctrlTab1.tabBarItem = UITabBarItem(title: ctrl.title, image: nil, selectedImage: nil)
       
        ctrl = ETMaterialsViewController()
        ctrl.title = NSLocalizedString("Materials", comment: "")
        let ctrlTab2 = UINavigationController(rootViewController: ctrl)
        ctrlTab2.tabBarItem = UITabBarItem(title: ctrl.title, image: nil, selectedImage: nil)
        
        ctrl = ETClientsViewController()
        ctrl.title = NSLocalizedString("Clients", comment: "")
        let ctrlTab3 = UINavigationController(rootViewController: ctrl)
        ctrlTab3.tabBarItem = UITabBarItem(title:  ctrl.title, image: nil, selectedImage: nil)
        
        ctrl = ETSettingsViewController()
        ctrl.title = NSLocalizedString("Settings", comment: "")
        let ctrlTab4 = UINavigationController(rootViewController: ctrl)
        ctrlTab4.tabBarItem = UITabBarItem(title:  ctrl.title, image: nil, selectedImage: nil)
        
        rootController.viewControllers = [ctrlTab1, ctrlTab2, ctrlTab3, ctrlTab4]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }
}

