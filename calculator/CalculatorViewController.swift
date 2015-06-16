//
//  ViewController.swift
//  calculator
//
//  Created by Toby Applegate on 05/03/2015.
//  Copyright (c) 2015 Toby Applegate. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    var isThereApoint = true
//    var openStack = Array<Double?>()
    var count = 0
    
    var brain = CalculatorBrain()
   
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var calcView: UILabel!
    
    //var historyStack = Array<String>()
    var userIsTyping = false

    @IBAction func numberButton(sender: UIButton) {
        let numberButton = sender.currentTitle!
        if calcView.text!.rangeOfString("=") != nil{
            calcView.text! = ""
        }

        if userIsTyping{
            calcView.text! = calcView.text! + numberButton
        }
        else {
            if numberButton == "PI" {
                calcView.text! = "\(M_PI)"
            }
            else {
            calcView.text! = numberButton
            userIsTyping = true
            }
        }
        
       
    }
    
    @IBAction func decimalPoint(sender: AnyObject) {
        if isThereApoint == true {
        calcView.text! = calcView.text! + "."
            isThereApoint = false
        }
    }
    
    var displayValue: Double? {
        get{
            if NSNumberFormatter().numberFromString(calcView.text!) != nil{
                return NSNumberFormatter().numberFromString(calcView.text!)!.doubleValue
                //numberFromstrig(calcview.text!) returns optional(9), second ! unwraps the optionsl 9 to a 9 and .doubleValue converts that to a double
            }
                //println("calc view in getter: \(calcView.text!)")
                return nil
        }
        set{
            
            if let value = newValue {
                calcView.text! = "= \(value)" 
                userIsTyping = false
            }
        }
    }

    @IBAction func operate(sender: UIButton) {
        if userIsTyping {
            enter()
        }
        if let operation = sender.currentTitle {
            //brain.description
            //history.text! =  "\(brain.description)" + ", "
            
            
            if let result = brain.performOperation(operation) {
                println("your result    :    \(result)")
                history.text! =  "\(brain.description)" + ", "
                displayValue = result 
                var observer = result { didSet { println("changed!") } }
            }
            else {
                history.text! =  "\(brain.description)" + ", "
                displayValue = nil
            }
        }
    }
    
    @IBAction func positiveOrNegative(sender: AnyObject) {
        if (calcView.text!.rangeOfString("-") != nil) {
            calcView.text! = dropFirst(calcView.text!)
        }
        else {
            calcView.text! = "-\(calcView.text!)"
        }
    }
    
    @IBAction func clearButton() {
        history.text! = ""
        brain.clear()
        calcView.text! = ""
    }

//    @IBAction func backspace(sender: AnyObject) {
//        if countElements(calcView.text!) > 0 {
//            calcView.text! = dropLast(calcView.text!)
//        }
//    }
    
    @IBAction func getM(sender: AnyObject) {
        //brain.variableValues["M"] = nil
        //if var x = brain.variableValues["M"]{
        //    println("\(x!)")
        //}
        brain.pushOperand("M")
        
    }
    
    
    //if let operation = knownOps[symbol]{ //if can look up operation in known ops then:
    //    opStack.append(operation)
    //}
    
    
    @IBAction func setM(sender: AnyObject) { //  →M
        
        if let M = displayValue {
            brain.variableValues["M"] = M
            var result =  brain.evaluate()
            userIsTyping = false
            history.text! = "\(brain.description)"
            if result != nil {
            displayValue = result!
            println("M : \(M)  result : \(result!)")
            }
            
        }
        
//        if brain.variableValues["M"] != nil {
//            brain.variableValues["M"] = displayValue!
//            var x = brain.variableValues["M"]
//            println("and the value is : \(x)")
//        userIsTyping = false
//        }
        
        
    }
    
    @IBAction func enter() {
        isThereApoint = true
        if history.text! == "History"{
            history.text! = ""
        }
            userIsTyping = false
        if let display = displayValue {
            history.text! = history.text! + "\(displayValue!)" + ", " //look at sorting this out! 
            if let result = brain.pushOperand(displayValue!){
                displayValue = result
            }
            else {
                displayValue = nil
            }
        }
            calcView.text! = ""
    }
}
















