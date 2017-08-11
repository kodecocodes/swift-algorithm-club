# Binary Tree Traversal
[Binary Tree Traversal]([Tree traversal - Wikipedia](https://en.wikipedia.org/wiki/Tree_traversal)) is a process of visiting each node in a tree. **Inorder**, **Preorder** and **Postorder** are 3 most popular algorithms. Use recursive, it will be pretty straight forward to write them.

## Inorder
Visit Order
> Left child tree  
> Root node  
> Right child tree   

```swift
public func traverse(_ node: TreeNode<T>?) {
  guard let node = node else {
    return
  }

  traverse(node.left)
  print(node.val)
  traverse(node.right)
}
```

## Preorder
Visit Order
> Root node  
> Left child tree  
> Right child tree  

```swift
public func traverse(_ node: TreeNode<T>?) {
  guard let node = node else {
    return
  }

  print(node.val)
  traverse(node.left)
  traverse(node.right)
}
```

## Postorder
Visit Order
> Left child tree  
> Right child tree  
> Root node  

```swift
public func traverse(_ node: TreeNode<T>?) {
  guard let node = node else {
    return
  }

  traverse(node.left)
  traverse(node.right)
  print(node.val)
}
```
