import Foundation

public enum BinarySearchTree<T: Comparable> {
    indirect case Node(Tree, T, Tree)
    case Leaf(T)
    case Empty

    public func insert(new: T) -> Tree {
        switch self {
        case .Leaf(let value):
            if new < value {
                return .Node(.Leaf(new), value, .Empty)
            } else {
                return .Node(.Empty, value, .Leaf(new))
            }
        case .Empty:
            return .Leaf(new)
        case .Node(let left, let value, let right):
            if new < value {
                return .Node(left.insert(new), value, right)
            } else {
                return .Node(left, value, right.insert(new))
            }
        }
    }

    public var height: Int {
        switch self {
            case .Empty: return 0
            case .Leaf(_): return 1
            case .Node(let left, _, let right): return 1 + max(left.height, right.height)
        }
    }
}

extension BinarySearchTree: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .Empty: return "<X>"
        case .Leaf(let v): return "\(v)"
        case .Node(let left, let value, let right): return "(\(left.debugDescription) <- \(value) -> \(right.debugDescription))"
        }
    }
}
