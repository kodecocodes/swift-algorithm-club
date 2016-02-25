//
//  ShuntingYardAlgorithm.swift
//
//
//  Created by Ali Hafizji on 2016-02-25.
//
//

import Foundation

internal enum OperatorAssociativity {
    case LeftAssociative
    case RightAssociative
}

internal enum OperatorType: CustomStringConvertible {
    case Add
    case Subtract
    case Divide
    case Multiply
    case Percent
    case Exponent
    
    var description: String {
        switch self {
        case Add:
            return "+"
        case Subtract:
            return "-"
        case Divide:
            return "/"
        case Multiply:
            return "*"
        case Percent:
            return "%"
        case Exponent:
            return "^"
        }
    }
}

internal struct OperatorToken: CustomStringConvertible {
    
    var operatorType: OperatorType
    
    init(operatorType: OperatorType) {
        self.operatorType = operatorType
    }
    
    var precedance: Int {
        switch operatorType {
        case .Add, .Subtract:
            return 0
        case .Divide, .Multiply, .Percent:
            return 5;
        case .Exponent:
            return 10
        }
    }
    
    var associativity: OperatorAssociativity {
        switch operatorType {
        case .Add, .Subtract, .Divide, .Multiply, .Percent:
            return .LeftAssociative;
        case .Exponent:
            return .RightAssociative
        }
    }
    
    var description: String {
        return operatorType.description
    }
}

func <=(left: OperatorToken, right: OperatorToken) -> Bool {
    if left.precedance <= right.precedance {
        return true
    }
    return false
}

func <(left: OperatorToken, right: OperatorToken) -> Bool {
    if left.precedance < right.precedance {
        return true
    }
    return false
}

internal enum TokenType: CustomStringConvertible {
    case OpenBracket
    case CloseBracket
    case Operator(OperatorToken)
    case Operand(Double)
    
    var description: String {
        switch self {
        case OpenBracket:
            return "("
        case CloseBracket:
            return ")"
        case Operator(let operatorToken):
            return operatorToken.description
        case Operand(let value):
            return "\(value)"
        }
    }
}

internal struct Token: CustomStringConvertible {
    
    var tokenType: TokenType
    
    init(tokenType: TokenType) {
        self.tokenType = tokenType
    }
    
    init(operand: Double) {
        tokenType = .Operand(operand)
    }
    
    init(operatorType: OperatorType) {
        tokenType = .Operator(OperatorToken(operatorType: operatorType))
    }
    
    var isOpenBracket: Bool {
        switch tokenType {
        case .OpenBracket:
            return true
        default:
            return false
        }
    }
    
    var isOperator: Bool {
        switch tokenType {
        case .Operator(_):
            return true
        default:
            return false
        }
    }
    
    var operatorToken: OperatorToken? {
        switch tokenType {
        case .Operator(let operatorToken):
            return operatorToken
        default:
            return nil
        }
    }
    
    var description: String {
        return tokenType.description
    }
}

public struct Expression {
    var expression = Array<Token>()
    
    init() {
        expression.append(Token(operand: 3))
        expression.append(Token(operatorType: OperatorType.Add))
        expression.append(Token(operand: 4))
        expression.append(Token(operatorType: OperatorType.Multiply))
        expression.append(Token(operand: 2))
        expression.append(Token(operatorType: OperatorType.Divide))
        expression.append(Token(tokenType: TokenType.OpenBracket))
        expression.append(Token(operand: 1))
        expression.append(Token(operatorType: OperatorType.Subtract))
        expression.append(Token(operand: 5))
        expression.append(Token(tokenType: TokenType.CloseBracket))
        expression.append(Token(operatorType: OperatorType.Exponent))
        expression.append(Token(operand: 2))
        expression.append(Token(operatorType: OperatorType.Exponent))
        expression.append(Token(operand: 3))
    }
    
    public func reversePolishNotation() -> String {
        
        var tokenStack = Stack<Token>()
        var reversePolishNotation = [Token]()
        
        for token in expression {
            switch token.tokenType {
            case .Operand(_):
                reversePolishNotation.append(token)
                break
            case .OpenBracket:
                tokenStack.push(token)
                break
            case .CloseBracket:
                while tokenStack.count > 0 {
                    if let tempToken = tokenStack.pop() where !tempToken.isOpenBracket {
                        reversePolishNotation.append(tempToken)
                    } else {
                        break
                    }
                }
                break
            case .Operator(let operatorToken):
                
                for tempToken in tokenStack.generate() {
                    if !tempToken.isOperator {
                        break
                    }
                    
                    if let tempOperatorToken = tempToken.operatorToken {
                        
                        if operatorToken.associativity == .LeftAssociative && operatorToken <= tempOperatorToken
                            || operatorToken.associativity == .RightAssociative && operatorToken < tempOperatorToken {
                                
                                reversePolishNotation.append(tokenStack.pop()!)
                        } else {
                            break
                        }
                    }
                }
                
                tokenStack.push(token)
                break
                
            }
        }
        
        while tokenStack.count > 0 {
            reversePolishNotation.append(tokenStack.pop()!)
        }
        
        return reversePolishNotation.map({token in
            return token.description
        }).joinWithSeparator(", ")
    }
}