//: Playground - noun: a place where people can play

import APSP

var graph = Graph<String>()

let v1 = graph.createVertex("Montreal")
let v2 = graph.createVertex("New York")
let v3 = graph.createVertex("Boston")
let v4 = graph.createVertex("Portland")
let v5 = graph.createVertex("Portsmouth")

graph.connect(v1, to: v2, withWeight: 3)
graph.connect(v1, to: v5, withWeight: -4)
graph.connect(v1, to: v3, withWeight: 8)

graph.connect(v2, to: v4, withWeight: 1)
graph.connect(v2, to: v5, withWeight: 7)

graph.connect(v3, to: v2, withWeight: 4)

graph.connect(v4, to: v1, withWeight: 2)
graph.connect(v4, to: v3, withWeight: -5)

graph.connect(v5, to: v4, withWeight: 6)

let result = FloydWarshall<String>.apply(graph)

let path = result.path(fromVertex: v1, toVertex: v4, inGraph: graph)