//
//  BinaryTreeTraversal.swift
//  
//
//  Created by kai_chen on 8/10/17.
//
//

import Foundation

public class TreeNode<T> {
  public var left: TreeNode?
  public var right: TreeNode?
  public var val: T

  public init(val: T) {
    self.val = val
  }
}

public class BTInorder<T> {

  public init() {}

  public func traverse(_ node: TreeNode<T>?) {
    guard let node = node else {
      return
    }

    traverse(node.left)
    print(node.val)
    traverse(node.right)
  }
}

public class BTPreorder<T> {

  public init() {}

  public func traverse(_ node: TreeNode<T>?) {
    guard let node = node else {
      return
    }

    print(node.val)
    traverse(node.left)
    traverse(node.right)
  }
}

public class BTPostorder<T> {

  public init() {}

  public func traverse(_ node: TreeNode<T>?) {
    guard let node = node else {
      return
    }

    traverse(node.left)
    traverse(node.right)
    print(node.val)
  }
}
