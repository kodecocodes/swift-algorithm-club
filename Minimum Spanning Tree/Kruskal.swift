//
//  Kruskal.swift
//  
//
//  Created by xiang xin on 16/3/17.
//
//

func minimumSpanningTreeKruskal<T>(graph: Graph<T>) -> (cost: Int, tree: Graph<T>) {
  var cost: Int = 0
  var tree = Graph<T>()
  let sortedEdgeListByWeight = graph.edgeList.sorted(by: { $0.weight < $1.weight })
  
  var unionFind = UnionFind<T>()
  for vertex in graph.vertices {
    unionFind.addSetWith(vertex)
  }
  
  for edge in sortedEdgeListByWeight {
    let v1 = edge.vertex1
    let v2 = edge.vertex2
    if !unionFind.inSameSet(v1, and: v2) {
      cost += edge.weight
      tree.addEdge(edge)
      unionFind.unionSetsContaining(v1, and: v2)
    }
  }
  
  return (cost: cost, tree: tree)
}
