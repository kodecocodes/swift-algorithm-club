class Graph {
  private var nodes = [Node]()

  func addNode(label: String) -> Node {
    let node = Node(label: label)
    nodes.append(node)
    return node
  }

  func addEdge(source: Node, neighbor: Node) {
    let edge = Edge(neighbor: neighbor)
    edge.neighbor = neighbor
    source.neighbors.append(edge)
  }
}

class Node : CustomStringConvertible, Equatable {
  private var label: String
  private var neighbors: [Edge]
  private var distance: Int?

  init(label: String) {
    self.label = label
    neighbors = []
  }

  var description: String {
    if let distance = distance {
      return "Node(label: \(label), distance: \(distance))"
    }
    return "Node(label: \(label), distance: infinity)"
  }

  var hasDistance: Bool {
    return distance != nil
  }
}

func ==(lhs: Node, rhs: Node) -> Bool {
  return lhs.label == rhs.label
}

class Edge {
  private var neighbor: Node

  init(neighbor: Node) {
    self.neighbor = neighbor
  }
}

struct Queue<T> {
  var array = [T]()

  var isEmpty: Bool {
    return array.isEmpty
  }

  var count: Int {
    return array.count
  }

  mutating func enqueue(element: T) {
    array.append(element)
  }

  mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }

  func peek() -> T? {
    return array.first
  }
}

func breadthFirstSearch(graph: Graph, source: Node) {
  print("Performing breadth-first search on '\(source.label)'")

  var seenNodes = [source]
  var queue = Queue<Node>()
  queue.enqueue(source)

  while !queue.isEmpty {
    let current = queue.dequeue()
    for edge in current!.neighbors {
      let neighborNode = edge.neighbor
      if !seenNodes.contains(neighborNode) {
        queue.enqueue(neighborNode)
        seenNodes.append(neighborNode)
        print(neighborNode.label)
      }
    }
  }
}

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
breadthFirstSearchShortestPath(graph, source: nodeA)
