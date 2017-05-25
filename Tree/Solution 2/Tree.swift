/**
 * Copyright (c) 2017 Gabriel von Dehn
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/*
 * An implementation of a general-purpose tree using enums
 */

// MARK: - TreeNode enum

enum TreeNode<T> {
  case Leaf(value: T)
  indirect case Node(value: T, children: [TreeNode])
  
  func add(child: TreeNode) -> TreeNode {
    switch self {
    case .Leaf(let ownValue):
      return .Node(value: ownValue, children: [child])
    case .Node(let ownValue, let ownChildren):
      return .Node(value: ownValue, children: ownChildren+[child])
    }
  }
}

// MARK: - extension: conforming to the CustomStringConvertible protocol

extension TreeNode: CustomStringConvertible {
  var description: String {
    switch self {
    case .Leaf(let value):
      return "\(value)"
    case .Node(let value, let children):
      return "\(value) {" + children.map { $0.description }.joined(separator: " ,") + "} "
    }
  }
}

// MARK: - extension: Searching

extension TreeNode where T: Equatable {
  func search(searching: T) -> TreeNode? {
    switch self {
    case .Leaf(let value):
      if searching == value {
        return self
      }
      
    case .Node(let value, let children):
      for child in children {
        if let found = child.search(searching) {
          return found
        }
      }
    }
    
    return nil
  }
}
