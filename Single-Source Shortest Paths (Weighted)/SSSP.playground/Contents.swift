import Graph
import SSSP

let graph = AdjacencyMatrixGraph<String>()
let s = graph.createVertex("s")
let t = graph.createVertex("t")
let x = graph.createVertex("x")
let y = graph.createVertex("y")
let z = graph.createVertex("z")

graph.addDirectedEdge(s, to: t, withWeight: 6)
graph.addDirectedEdge(s, to: y, withWeight: 7)

graph.addDirectedEdge(t, to: x, withWeight: 5)
graph.addDirectedEdge(t, to: y, withWeight: 8)
graph.addDirectedEdge(t, to: z, withWeight: -4)

graph.addDirectedEdge(x, to: t, withWeight: -2)

graph.addDirectedEdge(y, to: x, withWeight: -3)
graph.addDirectedEdge(y, to: z, withWeight: 9)

graph.addDirectedEdge(z, to: s, withWeight: 2)
graph.addDirectedEdge(z, to: x, withWeight: 7)

let result = BellmanFord<String>.apply(graph, source: s)!

let path = result.path(z, inGraph: graph)
