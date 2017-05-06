import Graph

for graph in [AdjacencyMatrixGraph<Int>(), AdjacencyListGraph<Int>()] {

  let v1 = graph.createVertex(1)
  let v2 = graph.createVertex(2)
  let v3 = graph.createVertex(3)
  let v4 = graph.createVertex(4)
  let v5 = graph.createVertex(5)

  // Set up a cycle like so:
  //               v5
  //                ^
  //                | (3.2)
  //                |
  // v1 ---(1)---> v2 ---(1)---> v3 ---(4.5)---> v4
  // ^                                            |
  // |                                            V
  // ---------<-----------<---------(2.8)----<----|

  graph.addDirectedEdge(v1, to: v2, withWeight: 1.0)
  graph.addDirectedEdge(v2, to: v3, withWeight: 1.0)
  graph.addDirectedEdge(v3, to: v4, withWeight: 4.5)
  graph.addDirectedEdge(v4, to: v1, withWeight: 2.8)
  graph.addDirectedEdge(v2, to: v5, withWeight: 3.2)

  // Returns the weight of the edge from v1 to v2 (1.0)
  graph.weightFrom(v1, to: v2)

  // Returns the weight of the edge from v1 to v3 (nil, since there is not an edge)
  graph.weightFrom(v1, to: v3)

  // Returns the weight of the edge from v3 to v4 (4.5)
  graph.weightFrom(v3, to: v4)

  // Returns the weight of the edge from v4 to v1 (2.8)
  graph.weightFrom(v4, to: v1)

  print(graph)
  print() // separate by a newline
}
