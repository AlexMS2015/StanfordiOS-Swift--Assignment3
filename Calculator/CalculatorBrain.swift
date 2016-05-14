//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Alex Smith on 9/05/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

import Foundation

class CalculatorBrain: CustomStringConvertible {
    
    // MARK: Private API
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case Variable(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Variable(let variable):
                    return variable
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private func evaluate(ops:[Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
                
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Variable(let variable):
                if let currVariable = variableValues[variable] {
                    return (currVariable, remainingOps)
                } else {
                    return (nil, remainingOps)
                }
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let op1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let op2 = op2Evaluation.result {
                        return (operation(op2, op1), op2Evaluation.remainingOps)
                    } else {
                        return (nil, ops)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    private func describe(ops:[Op]) -> (remainingOps: [Op], evalStr: String) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (remainingOps, "\(operand)")
            case .Variable(let variableName):
                return (remainingOps, "\(variableName)")
            case .UnaryOperation(let symbol, _):
                let opEvaluation = describe(remainingOps)
                return (opEvaluation.remainingOps, "\(symbol)(" + opEvaluation.evalStr + ")")
            case .BinaryOperation(let symbol, _):
                let op1Evaluation = describe(remainingOps)
                let op2Evaluation = describe(op1Evaluation.remainingOps)
                return (op2Evaluation.remainingOps, op2Evaluation.evalStr + symbol + op1Evaluation.evalStr)
            }
        }
        return (ops, "?")
    }
    
    // MARK: Non-private API
    
    var variableValues = [String: Double]()
    
    var description: String {
        get {
            if opStack.isEmpty {
                return ""
            }
            
            var (remainder, evalStr) = describe(opStack)
            var finalDesc = ""
            finalDesc += evalStr
            
            while !remainder.isEmpty {
                let (nextRemainder, evalStr) = describe(remainder)
                finalDesc = evalStr + ", " + finalDesc
                remainder = nextRemainder
            }
            
            return finalDesc
        }
    }
    
    init () {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("*", {return $1 * $0}))
        learnOp(Op.BinaryOperation("/", {return $1 / $0}))
        learnOp(Op.BinaryOperation("+", {return $1 + $0}))
        learnOp(Op.BinaryOperation("-", {return $1 - $0}))
        learnOp(Op.UnaryOperation("sq", sqrt))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.UnaryOperation("sin", sin))

    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    // allow the use of variables
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] { // optional in case not found in dictionary
            opStack.append(operation)
        }
        return evaluate()
    }
}
