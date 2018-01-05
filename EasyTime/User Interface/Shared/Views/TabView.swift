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
    static let inclineWidthPercent: CGFloat = 0.1
    static let controlPointPercent: CGFloat = 0.8
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
    
    func reloadData() {
        
        for subview in self.subviews {
            
            subview.removeFromSuperview()
        }
        
        if let delegate = self.delegate {
            
            let numberOfItems = delegate.numberOfItemsForTabView(tabView: self)
            for i in 0...(numberOfItems - 1) {
                
                let item = TabViewItem()
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
        }
    }
    
    func selectItem(at index: Int) {
        
        let numberOfItems = self.subviews.count
        for i in 0...(numberOfItems - 1) {
            
            if let item = self.subviews[i] as? UIButton {
                
                item.isSelected = i == index
                
                if item.isSelected == true {
                    
                    item.bringSubview(toFront: self)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let numberOfItems = self.subviews.count
        for i in 0...(numberOfItems - 1) {
            
            let itemWidth = self.frame.size.width / CGFloat(numberOfItems)
            let item = self.subviews[i]
            
            item.frame = CGRect(origin: CGPoint(x: itemWidth * CGFloat(i) - itemWidth * (Constants.curveWidthPercent + Constants.inclineWidthPercent / 2), y: 0),
                   size: CGSize(width: itemWidth * (1 + (Constants.curveWidthPercent + Constants.inclineWidthPercent / 2) * 2), height: self.frame.size.height))
        }
    }
    
    //MAKR: - Action handlers
    
    @objc func didTap(sender: UIButton) {
        
        if let index = self.subviews.index(of: sender) {
        
            self.selectItem(at: index)
            
            if let delegate = self.delegate {
                
                delegate.tabView(self, didSelectItemAtIndex: index)
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
    
    var fillColor: UIColor = UIColor.et_borderColor {
        
        didSet {
            
            self.setNeedsLayout()
        }
    }
    
    var selectedFillColor: UIColor = UIColor.et_blueColor {
        
        didSet {
            
            self.setNeedsLayout()
        }
    }
    
    required override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
        let curveWidth = rect.width * Constants.curveWidthPercent
        let controlWidth = curveWidth * Constants.controlPointPercent
        
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
                    x: rect.width * Constants.curveWidthPercent,
                    y: rect.height * (1 - Constants.curveWidthPercent)),
                                    controlPoint:
                CGPoint(
                    x: controlWidth,
                    y: rect.height))
            
            bezierPath.addLine(to:
                CGPoint(
                    x: rect.size.width * Constants.curveWidthPercent + rect.size.width * Constants.inclineWidthPercent,
                    y: rect.height * Constants.curveWidthPercent))
            
            bezierPath.addQuadCurve(to:
                CGPoint(
                    x: rect.size.width * Constants.curveWidthPercent * 2 + rect.size.width * Constants.inclineWidthPercent,
                    y: 0),
                                    controlPoint:
                CGPoint(
                    x: rect.size.width * Constants.curveWidthPercent * 2 + rect.size.width * Constants.inclineWidthPercent - controlWidth,
                    y: 0))
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
                    x: rect.size.width * (1 - Constants.curveWidthPercent * 2 - Constants.inclineWidthPercent),
                    y: 0))
            
            bezierPath.addQuadCurve(to:
                CGPoint(
                    x: rect.width * (1 - Constants.curveWidthPercent - Constants.inclineWidthPercent),
                    y: rect.height * Constants.curveWidthPercent),
                                    controlPoint:
                CGPoint(
                    x: rect.size.width * (1 - Constants.curveWidthPercent * 2 - Constants.inclineWidthPercent) + controlWidth,
                    y: 0))
            
            bezierPath.addLine(to:
                CGPoint(
                    x: rect.size.width * (1 - Constants.curveWidthPercent),
                    y: rect.height * (1 - Constants.curveWidthPercent)))
            
            bezierPath.addQuadCurve(to:
                CGPoint(
                    x: rect.width,
                    y: rect.height),
                                    controlPoint:
                CGPoint(
                    x: rect.width - controlWidth,
                    y: rect.height))
        }
        
        bezierPath.close()
        
        self.shapeLayer.path = bezierPath.cgPath
        self.shapeLayer.fillColor = self.isSelected ? self.selectedFillColor.cgColor : self.fillColor.cgColor
        self.layer.insertSublayer(self.shapeLayer, at: 0)
    }
}

