//
//  ShuntingYardAlgorithm.swift
//
//
//  Created by Ali Hafizji on 2016-02-25.
//
//

internal enum OperatorAssociativity {
  case leftAssociative
  case rightAssociative
}

public enum OperatorType: CustomStringConvertible {
  case add
  case subtract
  case divide
  case multiply
  case percent
  case exponent

  public var description: String {
    switch self {
      case add:
        return "+"
      case subtract:
        return "-"
      case divide:
        return "/"
      case multiply:
        return "*"
      case percent:
        return "%"
      case exponent:
        return "^"
    }
  }
}

public enum TokenType: CustomStringConvertible {
  case openBracket
  case closeBracket
  case Operator(OperatorToken)
  case operand(Double)

  public var description: String {
    switch self {
      case openBracket:
        return "("
      case closeBracket:
        return ")"
      case Operator(let operatorToken):
        return operatorToken.description
      case operand(let value):
        return "\(value)"
    }
  }
}

public struct OperatorToken: CustomStringConvertible {
  let operatorType: OperatorType

  init(operatorType: OperatorType) {
    self.operatorType = operatorType
  }

  var precedence: Int {
    switch operatorType {
      case .add, .subtract:
        return 0
      case .divide, .multiply, .percent:
        return 5
      case .exponent:
        return 10
    }
  }

  var associativity: OperatorAssociativity {
    switch operatorType {
      case .add, .subtract, .divide, .multiply, .percent:
        return .LeftAssociative
      case .exponent:
        return .RightAssociative
    }
  }

  public var description: String {
    return operatorType.description
  }
}

func <= (left: OperatorToken, right: OperatorToken) -> Bool {
  return left.precedence <= right.precedence
}

func < (left: OperatorToken, right: OperatorToken) -> Bool {
  return left.precedence < right.precedence
}

public struct Token: CustomStringConvertible {
  let tokenType: TokenType

  init(tokenType: TokenType) {
    self.tokenType = tokenType
  }

  init(operand: Double) {
    tokenType = .operand(operand)
  }

  init(operatorType: OperatorType) {
    tokenType = .Operator(OperatorToken(operatorType: operatorType))
  }

  var isOpenBracket: Bool {
    switch tokenType {
      case .openBracket:
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
  private var expression = [Token]()

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

  public func build() -> [Token] {
    // Maybe do some validation here
    return expression
  }
}

// This returns the result of the shunting yard algorithm
public func reversePolishNotation(expression: [Token]) -> String {

  var tokenStack = Stack<Token>()
  var reversePolishNotation = [Token]()

  for token in expression {
    switch token.tokenType {
      case .operand(_):
        reversePolishNotation.append(token)

      case .openBracket:
        tokenStack.push(token)

      case .closeBracket:
        while tokenStack.count > 0, let tempToken = tokenStack.pop(), !tempToken.isOpenBracket {
          reversePolishNotation.append(tempToken)
        }

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
    }
  }

  while tokenStack.count > 0 {
    reversePolishNotation.append(tokenStack.pop()!)
  }

  return reversePolishNotation.map({token in token.description}).joinWithSeparator(" ")
}
