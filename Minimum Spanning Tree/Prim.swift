//
//  Prim.swift
//  
//
//  Created by xiang xin on 16/3/17.
//
//

func minimumSpanningTreePrim<T>(graph: Graph<T>) -> (cost: Int, tree: Graph<T>) {
  var cost: Int = 0
  var tree = Graph<T>()
  
  guard let start = graph.vertices.first else {
    return (cost: cost, tree: tree)
  }
  
  var visited = Set<T>()
  var priorityQueue = PriorityQueue<(vertex: T, weight: Int, parent: T?)>(
    sort: { $0.weight < $1.weight })
  
  priorityQueue.enqueue((vertex: start, weight: 0, parent: nil))
  while let head = priorityQueue.dequeue() {
    let vertex = head.vertex
    if visited.contains(vertex) {
      continue
    }
    visited.insert(vertex)
    
    cost += head.weight
    if let prev = head.parent {
      tree.addEdge(vertex1: prev, vertex2: vertex, weight: head.weight)
    }
    
    if let neighbours = graph.adjList[vertex] {
      for neighbour in neighbours {
        let nextVertex = neighbour.vertex
        if !visited.contains(nextVertex) {
          priorityQueue.enqueue((vertex: nextVertex, weight: neighbour.weight, parent: vertex))
        }
      }
    }
  }
  
  return (cost: cost, tree: tree)
}
