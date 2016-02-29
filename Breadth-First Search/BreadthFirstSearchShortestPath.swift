func breadthFirstSearchShortestPath(graph: Graph, source: Node) {
  var queue = Queue<Node>()
  queue.enqueue(source)
  source.distance = 0

  while !queue.isEmpty {
    let current = queue.dequeue()!
    for edge in current.neighbors {
      let neighborNode = edge.neighbor
      if !neighborNode.hasDistance {
        queue.enqueue(neighborNode)
        neighborNode.distance = current.distance! + 1
      }
    }
  }

  print(graph.nodes)
}
