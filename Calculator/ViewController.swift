//
//  ViewController.swift
//  Calculator
//
//  Created by Alex Smith on 7/05/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    
    var currentlyTypingNumber = false
    var brain = CalculatorBrain()
    
    @IBAction func clearAndReset() {
        displayValue = 0
        historyLabel.text = ""
    }
    
    @IBAction func pi() {
        if currentlyTypingNumber {
            enter()
        }
        appendDisplay(String(M_PI))
        enter()
    }
    
    @IBAction func decimalPoint() {
        if display.text!.rangeOfString(".") == nil {
            appendDisplay(".")
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        appendDisplay(sender.currentTitle!)
    }
    
    func appendDisplay(append: String) {
        if currentlyTypingNumber {
            display.text = display.text! + append
        } else {
            display.text = append
            currentlyTypingNumber = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        historyLabel.text = historyLabel.text! + sender.currentTitle! + " "
        
        if currentlyTypingNumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        historyLabel.text = historyLabel.text! + display.text! + " "
        currentlyTypingNumber = false
        displayValue = brain.pushOperand(displayValue!)
//        if let result = brain.pushOperand(displayValue!) {
//            displayValue = result
//        } else {
//            displayValue = 0
//        }
    }
    
    var displayValue : Double? {
        get {
            if let currDisplay = display.text {
                return Double(currDisplay)
            } else {
                return nil
            }
            //return Double(display.text!)!
        }
        
        set(newValue) {
            if let currDisplay = newValue {
                display.text = "\(currDisplay)"
            } else {
                display.text = ""
            }
        }
    }
}

