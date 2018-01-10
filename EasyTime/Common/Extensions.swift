//
//  General.swift
//  easyService
//
//  Created by Yury Ramazanov on 05/05/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

extension UIColor {
    static let et_blueColor = UIColor(red: 62/255, green: 142/255, blue: 215/255, alpha: 1.0)
    static let et_borderColor = UIColor(red: 109 / 255, green: 137 / 255, blue: 175 / 255, alpha: 0.4)
}

extension UIView {

    class func loadFromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func loadFromNib () -> UIView? {
        return Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? UIView
    }
    
    func getFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        
        for subView in self.subviews {
            if let responder = subView.getFirstResponder() {
                return responder
            }
        }
        
        return nil
    }

    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }

    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leadingAnchor
        }else {
            return self.leadingAnchor
        }
    }

    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.trailingAnchor
        }else {
            return self.trailingAnchor
        }
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
}

extension Date {
    func toString(_ format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Bundle {
    class var appName: String {
        get{
            return main.object(forInfoDictionaryKey: "CFBundleName") as! String
        }
    }
}

extension String {

    mutating func append(_ string: String?, separator: String) {

        if let string = string {

            if self.characters.count > 0, string.characters.count > 0 {

                self.append(separator)
            }
            self.append(string)
        }
    }
}
