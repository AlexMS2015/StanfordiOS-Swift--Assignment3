//
//  GraphViewController.swift
//  Calculator
//
//  Created by Alex Smith on 19/05/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {
    
    @IBOutlet weak var equationLabel: UILabel!
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            addGestureRecognisers()
        }
    }
    
    func addGestureRecognisers() {
        let pinch = UIPinchGestureRecognizer(target: self, action: "pinch:")
        let pan = UIPanGestureRecognizer(target: self, action: "pan:")
        let doubleTap = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTap.numberOfTapsRequired = 2
        
        graphView.addGestureRecognizer(pinch)
        graphView.addGestureRecognizer(pan)
        graphView.addGestureRecognizer(doubleTap)
    }
    
    func pinch(gesture: UIPinchGestureRecognizer) {
        graphView.ptsPerUnit *= gesture.scale
        gesture.scale = 1.0
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(graphView)
        graphView.centreOffset.x += translation.x
        graphView.centreOffset.y += translation.y
        
        gesture.setTranslation(CGPoint(x: 0, y: 0), inView: graphView)
    }
    
    func doubleTap(gesture: UITapGestureRecognizer) {
    
    }
    
    var program: AnyObject? {
        didSet {
            brain.program = program!
            if equationLabel != nil { // in case the program is set before the UI is loaded
                updateUI()
            }
        }
    }
    
    override func viewDidLoad() {
        updateUI()
    }
    
    // MARK: GraphViewDataSource
    
    func yValueForX(sender: GraphView, x: Double) -> Double {
        if program != nil {
            brain.variableValues["M"] = x
            return brain.evaluate()!
        } else {
            return 0.0
        }
    }
    
    // MARK: Private API
    
    private let brain = CalculatorBrain()
    
    private func updateUI() {
//        graphView.setNeedsDisplay()
        equationLabel.text = brain.description //"Currently Graphing: " + brain.description
    }
}
