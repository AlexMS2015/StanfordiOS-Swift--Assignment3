//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Alex Smith on 9/05/2016.
//  Copyright © 2016 Alex Smith. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init () {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("x", {return $1 * $0}))
        learnOp(Op.BinaryOperation("/", {return $1 / $0}))
        learnOp(Op.BinaryOperation("+", {return $1 + $0}))
        learnOp(Op.BinaryOperation("-", {return $1 - $0}))
        learnOp(Op.UnaryOperation("sq", sqrt))
    }
    
    private func evaluate(ops:[Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            // let op = ops.removeLast()... will not work as non-object parameters are passed as a copy!
            var remainingOps = ops // copies ops because its an array which is a struct!
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
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
                    }
                }
            }
        }
        
        return (nil, ops)
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
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] { // optional in case not found in dictionary
            opStack.append(operation)
        }
        return evaluate()
    }
}
