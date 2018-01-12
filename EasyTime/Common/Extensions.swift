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

private var AssociatedObjectHandle: UInt8 = 0

extension UIView {

    open override var inputViewController: UIInputViewController? {
        get {

            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? UIInputViewController
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

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

            if self.count > 0, string.count > 0 {

                self.append(separator)
            }
            self.append(string)
        }
    }
}

extension UIButton {

    func alignVertical(spacing: CGFloat = 12.0) {

        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedStringKey.font: font])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
}
