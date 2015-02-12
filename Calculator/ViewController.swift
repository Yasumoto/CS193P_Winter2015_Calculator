//
//  ViewController.swift
//  Calculator
//
//  Created by Joseph Smith on 1/29/15.
//  Copyright (c) 2015 bjoli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber : Bool = false
    var operandStack = Array<Double>()
    var decimalNumberEntered = false

    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack = [Double]()
        decimalNumberEntered = false
        display.text = "\(0)"
        history.text = "\(0)"
    }
    
    @IBAction func decimalEntered() {
        if (!decimalNumberEntered && userIsInTheMiddleOfTypingANumber) || display.text! == "0" {
            userIsInTheMiddleOfTypingANumber = true
            display.text! += "."
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
            case "+":  performOperation { $0 + $1 }
            case "-":  performOperation { $0 - $1 }
            case "×":  performOperation { $0 * $1 }
            case "÷":  performOperation { $1 / $0 }
            case "√":  performSingleOperation { sqrt($0) }
            case "sin": performSingleOperation { sin($0) }
            case "cos": performSingleOperation { cos($0) }
            case "π": appendConstant(M_PI)
            default : break
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    /* Is this some newfangled Swift 1.2 compiler bug?
        'Method 'performOperation' redeclares Objective-C method 'performOperation:'
    */
    func performSingleOperation(operation: (Double) -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func appendConstant (constant : Double) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        display.text = "\(constant)"
        enter()
        
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

