//: Playground - noun: a place where people can play

// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

import UIKit

let graph = Graph()

let node5 = graph.addNode("5")
let node7 = graph.addNode("7")
let node3 = graph.addNode("3")
let node11 = graph.addNode("11")
let node8 = graph.addNode("8")
let node2 = graph.addNode("2")
let node9 = graph.addNode("9")
let node10 = graph.addNode("10")

graph.addEdge(fromNode: node5, toNode: node11)
graph.addEdge(fromNode: node7, toNode: node11)
graph.addEdge(fromNode: node7, toNode: node8)
graph.addEdge(fromNode: node3, toNode: node8)
graph.addEdge(fromNode: node3, toNode: node10)
graph.addEdge(fromNode: node11, toNode: node2)
graph.addEdge(fromNode: node11, toNode: node9)
graph.addEdge(fromNode: node11, toNode: node10)
graph.addEdge(fromNode: node8, toNode: node9)

// using depth-first search
graph.topologicalSort()

// also using depth-first search
graph.topologicalSortAlternative()

// Kahn's algorithm
graph.topologicalSortKahn()
