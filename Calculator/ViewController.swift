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
    
    var currentlyTypingNumber = false;
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if currentlyTypingNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            currentlyTypingNumber = true;
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if currentlyTypingNumber {
            enter()
        }
        
        let operation = sender.currentTitle!
        
        switch operation {
        case "*": performOperation({ return $0 * $1 })
        case "/": performOperation({ return $1 / $0 })
        case "+": performOperation({ return $0 + $1 })
        case "-": performOperation({ return $1 - $0 })
        case "sq": performOperation({ return sqrt($0) })
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            operandStack.append(displayValue)
            print(operandStack)
        }
    }

    @nonobjc
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            operandStack.append(displayValue)
            print(operandStack)
        }
    }
    
    var operandStack = Array<Double>()
    @IBAction func enter() {
        operandStack.append(displayValue)
        currentlyTypingNumber = false;
        print(operandStack)
    }
    
    var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = "\(newValue)"
        }
        
    }

}

