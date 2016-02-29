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

/*:
![Animated example of a breadth-first search](Animated_BFS.gif)
*/

let graph = Graph()

let nodeA = graph.addNode("a")
let nodeB = graph.addNode("b")
let nodeC = graph.addNode("c")
let nodeD = graph.addNode("d")
let nodeE = graph.addNode("e")
let nodeF = graph.addNode("f")
let nodeG = graph.addNode("g")
let nodeH = graph.addNode("h")

graph.addEdge(nodeA, neighbor: nodeB)
graph.addEdge(nodeA, neighbor: nodeC)
graph.addEdge(nodeB, neighbor: nodeD)
graph.addEdge(nodeB, neighbor: nodeE)
graph.addEdge(nodeC, neighbor: nodeF)
graph.addEdge(nodeC, neighbor: nodeG)
graph.addEdge(nodeE, neighbor: nodeH)


breadthFirstSearch(graph, source: nodeA)
