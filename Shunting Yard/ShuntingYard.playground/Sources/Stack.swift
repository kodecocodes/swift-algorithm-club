import Foundation

public struct Stack<T> {
    private var array = [T]()

    public init() {
        array = []
    }

    public var isEmpty: Bool {
        return array.isEmpty
    }

    public var count: Int {
        return array.count
    }

    public mutating func push(element: T) {
        array.append(element)
    }

    public mutating func pop() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeLast()
        }
    }

    public func peek() -> T? {
        return array.last
    }
}

extension Stack: SequenceType {
    public func generate() -> AnyGenerator<T> {
        var curr = self
        return anyGenerator {
            _ -> T? in
            return curr.pop()
        }
    }
}
