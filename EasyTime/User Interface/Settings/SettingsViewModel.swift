//
//  SettingsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 12/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class SettingsViewModel: BaseViewModel {

    let settingItems = [SettingItem(icon: UIImage(named: "icon")!, title: NSLocalizedString("Help", comment: "")),
                        SettingItem(icon: UIImage(named: "icon star")!, title: NSLocalizedString("Send Feedback", comment: "")),
                        SettingItem(icon: UIImage(named: "icon logout")!, title: NSLocalizedString("Logout", comment: ""))]

    lazy var appVersionString: String = {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        return String(format: "EasyTime v%@\nCopyright 2018. All Rights Reserved", version)
    } ()
    
    subscript(indexPath: IndexPath) -> SettingItem {
        return self.settingItems[indexPath.row]
    }
    
    func numberOfRows() -> Int {
        return self.settingItems.count
    }
    
}

struct SettingItem {
    var icon: UIImage
    var title: String
}
