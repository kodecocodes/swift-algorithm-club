func breadthFirstSearch(graph: Graph, source: Node) {
  var queue = Queue<Node>()
  queue.enqueue(source)

  print(source.label)

  while !queue.isEmpty {
    let current = queue.dequeue()!
    for edge in current.neighbors {
      let neighborNode = edge.neighbor
      if !neighborNode.visited {
        queue.enqueue(neighborNode)
        neighborNode.visited = true
        print(neighborNode.label)
      }
    }
  }
}
