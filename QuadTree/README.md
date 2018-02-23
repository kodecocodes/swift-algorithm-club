# QuadTree

A quadtree is a [tree](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Tree) in which each internal (not leaf) node has four children.

<img src="https://github.com/timaktimak/swift-algorithm-club/blob/master/QuadTree/Images/quadtree.png" width="500">

### Problem

Consider the following problem: your need to store a number of points (each point is a pair of `X` and `Y` coordinates) and then you need to answer which points lie in a certain rectangular region. A naive solution would be to store the points inside an array and then iterate over the points and check each one individually. This solution runs in O(n) though.

### A Better Approach

Quadtrees are most commonly used to partition a two-dimensional space by recursively subdividing it into four regions(quadrants). Let's see how we can use a Quadtree to store the points.

Each node in the tree represents a rectangular region and stores a limited number(`maxPointCapacity`) of points that all lie in its region.

```swift
class QuadTreeNode {

  enum NodeType {
    case leaf
    case `internal`(children: Children)
  }

  struct Children {
    let leftTop: QuadTreeNode
    let leftBottom: QuadTreeNode
    let rightTop: QuadTreeNode
    let rightBottom: QuadTreeNode

    ...
  }

  var points: [Point] = []
  let rect: Rect
  var type: NodeType = .leaf

  static let maxPointCapacity = 3

  init(rect: Rect) {
    self.rect = rect
  }

  ...
}

```
Once the limit in a leaf node is reached, four child nodes are added to the node and they represent `topLeft`, `topRight`, `bottomLeft`, `bottomRight` quadrants of the node's rect; each of the consequent points in the rect will be passed to one of the children. Thus, new points are always added to leaf nodes.

```swift
extension QuadTreeNode {

  @discardableResult
  func add(point: Point) -> Bool {

    if !rect.contains(point: point) {
      return false
    }

    switch type {
    case .internal(let children):
      // pass the point to one of the children
      for child in children {
        if child.add(point: point) {
          return true
        }
      }
      return false // should never happen
    case .leaf:
      points.append(point)
      // if the max capacity was reached, become an internal node
      if points.count == QuadTreeNode.maxPointCapacity {
        subdivide()
      }
    }
    return true
  }

  private func subdivide() {
    switch type {
    case .leaf:
      type = .internal(children: Children(parentNode: self))
    case .internal:
      preconditionFailure("Calling subdivide on an internal node")
    }
  }
}

extension Children {

  init(parentNode: QuadTreeNode) {
    leftTop = QuadTreeNode(rect: parentNode.rect.leftTopRect)
    leftBottom = QuadTreeNode(rect: parentNode.rect.leftBottomRect)
    rightTop = QuadTreeNode(rect: parentNode.rect.rightTopRect)
    rightBottom = QuadTreeNode(rect: parentNode.rect.rightBottomRect)
  }
}

```

To find the points that lie in a given region we can now traverse the tree from top to bottom and collect the suitable points from nodes.

```swift

class QuadTree {

  ...

  let root: QuadTreeNode

   public func points(inRect rect: Rect) -> [Point] {
    return root.points(inRect: rect)
  }
}

extension QuadTreeNode {
  func points(inRect rect: Rect) -> [Point] {

    // if the node's rect and the given rect don't intersect, return an empty array,
    // because there can't be any points that lie the node's (or its children's) rect and
    // in the given rect
    if !self.rect.intersects(rect: rect) {
      return []
    }

    var result: [Point] = []

    // collect the node's points that lie in the rect
    for point in points {
      if rect.contains(point: point) {
        result.append(point)
      }
    }

    switch type {
    case .leaf:
      break
    case .internal(children: let children):
      // recursively add children's points that lie in the rect
      for childNode in children {
        result.append(contentsOf: childNode.points(inRect: rect))
      }
    }

    return result
  }
}

```

Both adding a point and searching can still take up to O(n) in the worst case, since the tree isn't balanced in any way. However, on average it runs significantly faster (something comparable to O(log n)).

### See also

Displaying a large amount of objects in a MapView - a great use case for a Quadtree ([Thoughtbot Article](https://robots.thoughtbot.com/how-to-handle-large-amounts-of-data-on-maps))

More info on [Wikipedia](https://en.wikipedia.org/wiki/Quadtree)

*Written for Swift Algorithm Club by Timur Galimov*
