//: Playground - noun: a place where people can play

import Foundation

internal enum OperatorAssociativity {
  case LeftAssociative
  case RightAssociative
}

public enum OperatorType: CustomStringConvertible {
  case Add
  case Subtract
  case Divide
  case Multiply
  case Percent
  case Exponent
  
  public var description: String {
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

public enum TokenType: CustomStringConvertible {
  case OpenBracket
  case CloseBracket
  case Operator(OperatorToken)
  case Operand(Double)
  
  public var description: String {
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

public struct OperatorToken: CustomStringConvertible {
  
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
  
  public var description: String {
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

public struct Token: CustomStringConvertible {
  
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
  
  public var description: String {
    return tokenType.description
  }
}

public class InfixExpressionBuilder {
  
  private var expression = Array<Token>()
  
  public func addOperator(operatorType: OperatorType) -> InfixExpressionBuilder {
    expression.append(Token(operatorType: operatorType))
    return self
  }
  
  public func addOperand(operand: Double) -> InfixExpressionBuilder {
    expression.append(Token(operand: operand))
    return self
  }
  
  public func addOpenBracket() -> InfixExpressionBuilder {
    expression.append(Token(tokenType: .OpenBracket))
    return self
  }
  
  public func addCloseBracket() -> InfixExpressionBuilder {
    expression.append(Token(tokenType: .CloseBracket))
    return self
  }
  
  public func build() -> Array<Token> {
    // Maybe do some validation here
    return expression
  }
}

// This returns the result of the shunting yard algorithm
public func reversePolishNotation(expression: Array<Token>) -> String {
  
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
  }).joinWithSeparator(" ")
}

print(reversePolishNotation(InfixExpressionBuilder().addOperand(3).addOperator(.Add).addOperand(4).addOperator(.Multiply).addOperand(2).addOperator(.Divide).addOpenBracket().addOperand(1).addOperator(.Subtract).addOperand(5).addCloseBracket().addOperator(.Exponent).addOperand(2).addOperator(.Exponent).addOperand(3).build()))
