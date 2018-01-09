//
//  TabView.swift
//  EasyTime
//
//  Created by Sergei Kvasov on 1/5/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//
import UIKit

fileprivate struct Constants {
    
    static let curveWidthPercent: CGFloat = 0.05
    static let inclineWidthPercent: CGFloat = 0.07
    static let controlXPercent: CGFloat = 0.6
    static let controlYPercent: CGFloat = 0.9
    static let fontSize: CGFloat = 14
    static let textColor = UIColor(red: 65 / 255, green: 91 / 255, blue: 128 / 255, alpha: 1)
    static let selectedTextColor = UIColor.black
    static let fillColor = UIColor(red: 175 / 255, green: 190 / 255, blue: 211 / 255, alpha: 1)
    static let selectedFillColor = UIColor.white
}

enum TabViewItemPosition {
    
    case left
    case right
    case middle
}

protocol TabViewDelegate: class {
    
    func numberOfItemsForTabView(tabView: TabView) -> Int
    func tabView(_ tabView: TabView, titleForItemAtIndex index: Int) -> String?
    func tabView(_ tabView: TabView, didSelectItemAtIndex index: Int)
}

class TabView: UIView {
    
    weak var delegate: TabViewDelegate? {
        
        didSet {
            
            self.reloadData()
        }
    }

    var selectedIndex: Int = 0 {

        didSet {

            self.selectItem(at: self.selectedIndex)
        }
    }
    
    func reloadData() {
        
        for subview in self.subviews {
            
            subview.removeFromSuperview()
        }
        
        if let delegate = self.delegate {
            
            let numberOfItems = delegate.numberOfItemsForTabView(tabView: self)
            for i in 0...(numberOfItems - 1) {
                
                let item = TabViewItem()
                item.tag = i
                item.setTitle(delegate.tabView(self, titleForItemAtIndex: i), for: .normal)
                item.addTarget(self, action: #selector(TabView.didTap(sender:)), for: .touchUpInside)
                
                if i == 0 && numberOfItems > 1 {
                    
                    item.position = .left
                }
                else if i == numberOfItems - 1 && numberOfItems > 1 {
                    
                    item.position = .right
                }
                else {
                    
                    item.position = .middle
                }
                
                self.addSubview(item)
            }
            self.selectItem(at: self.selectedIndex)
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let numberOfItems = self.subviews.count
        for item in self.subviews {
            
            let itemWidth = self.frame.size.width / CGFloat(numberOfItems)
            let index = item.tag
            item.frame = CGRect(origin: CGPoint(x: itemWidth * CGFloat(index) - itemWidth * (Constants.curveWidthPercent + Constants.inclineWidthPercent / 2), y: 0),
                                size: CGSize(width: itemWidth * (1 + (Constants.curveWidthPercent + Constants.inclineWidthPercent / 2) * 2), height: self.frame.size.height))
        }
    }
    
    //MAKR: - Action handlers
    
    @objc func didTap(sender: UIButton) {
        
        let index = sender.tag
        self.selectItem(at: index)

        if let delegate = self.delegate {

            delegate.tabView(self, didSelectItemAtIndex: index)
        }
    }

    //MARK: - Private functions

    private func selectItem(at index: Int) {

        for item in self.subviews {

            let i = item.tag
            if let item = item as? UIButton {

                item.isSelected = i == index

                if item.isSelected == true {

                    self.bringSubview(toFront: item)
                }
            }
        }
    }
}

private class TabViewItem: UIButton
{
    lazy var shapeLayer: CAShapeLayer = {
       
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        return layer
    }()
    
    var position: TabViewItemPosition = .middle {
        
        didSet {
            
            self.setNeedsLayout()
        }
    }
    
    init() {

        super.init(frame: CGRect.zero)

        self.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontSize)
        self.titleLabel?.textColor = Constants.textColor
        self.setTitleColor(Constants.textColor, for: .normal)
        self.setTitleColor(Constants.selectedTextColor, for: .selected)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect)
    {
        let curveWidth = rect.width * Constants.curveWidthPercent
        let controlWidth = curveWidth * Constants.controlXPercent
        let controlHeight = curveWidth * Constants.controlYPercent
        let inclineWidth = rect.width * Constants.inclineWidthPercent
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: rect.height))
        
        if self.position == .left {
            
            bezierPath.addLine(to:
                CGPoint(
                    x: 0,
                    y: 0))
        }
        else {
            
            bezierPath.addQuadCurve(to:
                CGPoint(
                    x: curveWidth,
                    y: rect.height - curveWidth),
                                    controlPoint:
                CGPoint(
                    x: controlWidth,
                    y: rect.height - curveWidth + controlHeight))
            
            bezierPath.addLine(to:
                CGPoint(
                    x: curveWidth + inclineWidth,
                    y: curveWidth))

            bezierPath.addQuadCurve(to:
                CGPoint(
                    x: curveWidth * 2 + inclineWidth,
                    y: 0),
                                    controlPoint:
                CGPoint(
                    x: curveWidth * 2 + inclineWidth - controlWidth,
                    y: curveWidth - controlHeight))
        }
        
        if self.position == .right {
            
            bezierPath.addLine(to:
                CGPoint(
                    x: rect.width,
                    y: 0))
            
            bezierPath.addLine(to:
                CGPoint(
                    x: rect.width,
                    y: rect.height))
        }
        else {
            
            bezierPath.addLine(to:
                CGPoint(
                    x: rect.size.width - inclineWidth - 2 * curveWidth,
                    y: 0))
            
            bezierPath.addQuadCurve(to:
                CGPoint(
                    x: rect.width - inclineWidth - curveWidth,
                    y: curveWidth),
                                    controlPoint:
                CGPoint(
                    x: rect.size.width - inclineWidth - 2 * curveWidth + controlWidth,
                    y: curveWidth - controlHeight))
            
            bezierPath.addLine(to:
                CGPoint(
                    x: rect.size.width - curveWidth,
                    y: rect.height - controlHeight))
            
            bezierPath.addQuadCurve(to:
                CGPoint(
                    x: rect.width,
                    y: rect.height),
                                    controlPoint:
                CGPoint(
                    x: rect.width - controlWidth,
                    y: rect.height - curveWidth + controlHeight))
        }
        
        bezierPath.close()
        
        self.shapeLayer.path = bezierPath.cgPath
        self.shapeLayer.fillColor = self.isSelected ? Constants.selectedFillColor.cgColor : Constants.fillColor.cgColor
        self.layer.insertSublayer(self.shapeLayer, at: 0)
    }
}

