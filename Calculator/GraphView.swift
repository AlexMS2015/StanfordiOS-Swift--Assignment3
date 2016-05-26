//
//  GraphView.swift
//  Calculator
//
//  Created by Alex Smith on 20/05/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

import UIKit

extension UIView {
    var centreInbounds: CGPoint {
        get {
            return CGPointMake(bounds.size.width / 2, bounds.size.height / 2)
        }
    }
}

protocol GraphViewDataSource: class { // can only be implemented by a class (no structs or enums)
    func yValueForX(sender: GraphView, x: Double) -> Double
}

@IBDesignable
class GraphView: UIView {
    
    weak var dataSource: GraphViewDataSource? // only works on 'class' protocols
    var centreOffset = CGPoint(x: 0, y: 0) {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var ptsPerUnit: CGFloat = 3.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {
        let axes = AxesDrawer(contentScaleFactor: contentScaleFactor)
        axes.drawAxesInRect(self.bounds, origin: adjustedCentre, pointsPerUnit: ptsPerUnit)
        
        if dataSource != nil {
            let graph = UIBezierPath()
            for xVal in -maxX...maxX {
                
                let yVal = dataSource!.yValueForX(self, x: Double(xVal))
                let currentPoint = convertXandYIntoBounds(x: CGFloat(xVal), y: CGFloat(yVal))
                
                xVal == -maxX ? graph.moveToPoint(currentPoint) : graph.addLineToPoint(currentPoint)
            }
            
            UIColor.blueColor().set()
            graph.stroke()
        }
    }
    
    // MARK: Private API
    
    private var adjustedCentre: CGPoint {
        return CGPoint(x: centreInbounds.x + centreOffset.x, y: centreInbounds.y + centreOffset.y)
    }
    
    private var maxX: Int {
        get {
            return Int(self.bounds.width) / (2 * Int(ptsPerUnit))
        }
    }
    
    private func convertXandYIntoBounds(x x: CGFloat, y: CGFloat) -> CGPoint {
        let adjustedX = x * ptsPerUnit + self.bounds.width / 2.0
        let adjustedY = self.adjustedCentre.y - (ptsPerUnit * y)
        return CGPoint(x: adjustedX, y: adjustedY)
    }
    
}
