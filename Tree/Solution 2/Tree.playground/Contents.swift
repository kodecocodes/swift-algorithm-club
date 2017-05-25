//: Playground - noun: a place where people can play

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

extension TreeNode: CustomStringConvertible {
  var description: String {
    switch self {
    case .Leaf(let value):
      return "\(value)"
    case .Node(let value, let children):
      return "\(value) {" + children.map { $0.description }.joined(separator: ", ") + "} "
    }
  }
}




var tree = TreeNode.Leaf(value: "beverages")

var hotNode = TreeNode.Leaf(value: "hot")
var coldNode = TreeNode.Leaf(value: "cold")

var teaNode = TreeNode.Leaf(value: "tea")
var coffeeNode = TreeNode.Leaf(value: "coffee")
var chocolateNode = TreeNode.Leaf(value: "cocoa")

var blackTeaNode = TreeNode.Leaf(value: "black")
var greenTeaNode = TreeNode.Leaf(value: "green")
var chaiTeaNode = TreeNode.Leaf(value: "chai")

var sodaNode = TreeNode.Leaf(value: "soda")
var milkNode = TreeNode.Leaf(value: "milk")

var gingerAleNode = TreeNode.Leaf(value: "ginger ale")
var bitterLemonNode = TreeNode.Leaf(value: "bitter lemon")

sodaNode = sodaNode.add(gingerAleNode)
sodaNode = sodaNode.add(bitterLemonNode)

teaNode = teaNode.add(blackTeaNode)
teaNode = teaNode.add(greenTeaNode)
teaNode = teaNode.add(chaiTeaNode)

coldNode = coldNode.add(sodaNode)
coldNode = coldNode.add(milkNode)

hotNode = hotNode.add(teaNode)
hotNode = hotNode.add(coffeeNode)
hotNode = hotNode.add(chocolateNode)

tree = tree.add(hotNode)
tree = tree.add(coldNode)

tree

extension TreeNode where T: Equatable {
  func search(searching: T) -> TreeNode? {
    switch self {
    case .Leaf(let value):
      print(value)
      if searching == value {
        return self
      }
      
    case .Node(let value, let children):
      print(value)
      if searching == value {
        return self
      }
      
      for child in children {
        if let found = child.search(searching) {
          return found
        }
      }
    }
    
    return nil
  }
}

tree.search("cocoa")
tree.search("chai")
tree.search("bubbly")
