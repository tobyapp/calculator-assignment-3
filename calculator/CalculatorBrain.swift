//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Toby Applegate on 06/05/2015.
//  Copyright (c) 2015 Toby Applegate. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op : Printable {
        case Variable(String)
        case Operand(Double) //operand is just a number e.g. 4
        case UnaryOperation(String, Double -> Double)  //in swift function (double -> double) is a type, the same as string
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description : String {
            get{
                switch self {
                case .Variable(let variable):
                    return variable
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    //println("\(opStack)")
                    //var statement = "\(symbol)(\(value))"
                    //println(statement)
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    var variableValues = [String:Double?]()
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)//{$0 * $1} //need to provide function that takes two doubles and returns a double, in swift '*' is a function that does this, same for the operations below but not '/' or '-' as order is backwards
        knownOps["÷"] = Op.BinaryOperation("÷"){$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", +)//{$0 + $1}
        knownOps["−"] = Op.BinaryOperation("−"){$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)//{sqrt($0)}
        knownOps["Cos"] = Op.UnaryOperation("Cos"){cos($0)}
        knownOps["Sin"] = Op.UnaryOperation("Sin"){sin($0)}
        knownOps["M"] = Op.Variable("M")
        //case "PI":  displayValue! = M_PI
        
    }
    
    var program: AnyObject { //guarenteed to be a propertie list
        get {
           // return opStack.map { $0.descriptopm}
            var returnValue = Array<String>()
            for op in opStack {
                returnValue.append(op.description)
            }
            return returnValue
        }
        
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpstack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpstack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpstack.append(.Operand(operand))
                    }
                }
                opStack = newOpstack
            }
        }
    }
    
    private func evaluate(ops : [Op]) -> (result : Double?, remainingOps : [Op]){ //returns result plus Op(s) that are left over in passed in array (NOTE: doesnt pass in whole array (opStack))
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast() //op is op pulled off stack so remainingOps really is the remaining ops on the stack because removed top one on stack using .removeLast()
            switch op { //have switch staement so we can get associated value from enum
                
                case .Variable(let variable):
                    if let value = variableValues[variable] {
                        
                        return (value, remainingOps)
                    }
                
                case .Operand(let operand): //let asscioated value be equals to constant operand
                    return( operand, remainingOps) //returned tuple
                
                case .UnaryOperation(let op, let operation): //Only evaluating function so dont care what string (e.g. '+') is so put '_' (we dont care)
                    let operandEvaluation = evaluate(remainingOps) //recursed incase next op on stack is operation ('+') and not operand (5)
                    if let operand = operandEvaluation.result {
                    return(operation(operand), operandEvaluation.remainingOps) //operation is Double -> Double e.g. sqrt(5)
                }
                
                case .BinaryOperation(let op, let operation):
                    let op1Evaluation = evaluate(remainingOps)
                    if let operand1 = op1Evaluation.result {
                        let op2evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2evaluation.result {
                            return (operation(operand1,operand2), op2evaluation.remainingOps)
                        }
                    }
                }
            }
        return (nil, ops) //return nil if fail (run out of operands or stack)
    }

//    var description: String {
//        get {
//            var stack = opStack
//            var (statement, _, _) = evaluate(stack)
//            if let descrip = statement {
//                println("statement: \(descrip)")
//                return("statement: \(descrip)")
//            }
//            return "?"
//        }

//    }
    
    var variableM : Double? {
        get{
            return variableValues["M"]!
        }
        
        set {
            variableValues["M"] = variableM
        }
    }
    
    var description : String {
        get {
            var stack = opStack
            var output = ""
            do {
                var statement : String?
                (statement, stack) = description(stack)
                output = output == "" ? statement! : "\(statement!), \(output)"
                
                println("output : \(output)")
                
            } while stack.count > 0
                return output
        }
    }

    
    private func description(ops : [Op]) -> (result : String?, remainingOps : [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
                
            case .Variable(let variable):
                //if let value = variableValues[variable] {
                    return (variable, remainingOps)
                //}
                
            case .Operand(let operand):
                return("\(operand)", remainingOps)
                
            case .UnaryOperation(let op, _):
                let operandEvaluation = description(remainingOps)
                if let operand = operandEvaluation.result {
                    return("\(op)(\(operand))", operandEvaluation.remainingOps)
                } 

            case .BinaryOperation(let op, let operation):
                let op1Evaluation = description(remainingOps)
                if var operand1 = op1Evaluation.result {
                    if remainingOps.count - op1Evaluation.remainingOps.count > 2 {
                        operand1 = "\(operand1)"
                    }
                    let op2evaluation = description(op1Evaluation.remainingOps)
                    if let operand2 = op2evaluation.result {
                        return ("\(operand2)  \(op)  \(operand1)", op2evaluation.remainingOps)
                    }
                }
            }
        }
        return ("?", ops)
    }

    
    func evaluate() -> Double? { //needs to be optional incase someone first presses '+' when the calc boots up, theres no operands on stack so would be error
        let (result, remainder) = evaluate(opStack)
        var desc = description
        if result != nil {
        println("\(opStack) = \(result!) with \(remainder) left over")
        return result
        }
        else {
            return nil
        }
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? { //CHECK!!
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]{ //if can look up operation in known ops then:
            opStack.append(operation)
        }
        var observer = evaluate() 
        return observer
    }
    
    func clear() {
        for item in opStack{
            opStack.removeLast()
        }
        println("")
        variableValues.removeAll()
    }
}
























