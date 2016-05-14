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
        brain = CalculatorBrain()
        displayValue = 0
        currentlyTypingNumber = false
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
        if currentlyTypingNumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            displayValue = brain.performOperation(operation)
        }
    }
    
    @IBAction func enter() {
        currentlyTypingNumber = false
        displayValue = brain.pushOperand(displayValue!)
    }
    
    var displayValue : Double? {
        get {
            if let currDisplay = display.text {
                return Double(currDisplay)
            } else {
                return nil
            }
        }
        
        set(newValue) {
            historyLabel.text = " " + brain.description
            if let currDisplay = newValue {
                display.text = "\(currDisplay)"
            } else {
                display.text = "Error"
            }
        }
    }
}

