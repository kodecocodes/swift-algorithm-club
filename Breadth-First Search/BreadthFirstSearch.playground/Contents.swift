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

class Node {
  private var label: String
  private var neighbors: [Edge]

  init(label: String) {
    self.label = label
    neighbors = []
  }
}

class Edge {
  private var neighbor: Node

  init(neighbor: Node) {
    self.neighbor = neighbor
  }
}

class Queue<T> {
  private var top: QueueNode<T>!

  func enqueue(item: T) {
    if (top == nil) {
      top = QueueNode<T>()
    }

    if (top.item == nil) {
      top.item = item;
      return
    }

    let childToUse = QueueNode<T>()
    var current: QueueNode = top
    while current.next != nil {
      current = current.next!
    }

    childToUse.item = item;
    current.next = childToUse;
  }

  func dequeue() -> QueueNode<T>? {
    guard !isEmpty else {
      return nil
    }

    let itemToDequeue = top
    top = itemToDequeue.next
    return itemToDequeue
  }

  var isEmpty: Bool {
    get { return top == nil }
  }
}

class QueueNode<T> {
  var item: T?
  var next: QueueNode?
}

func breadthFirstSearch(graph: Graph, root: Node) {
  print("Performing breadth-first search on '\(root.label)'")

  let q = Queue<Node>()
  q.enqueue(root)

  while !q.isEmpty {
    let current = q.dequeue()
    for edge in current!.item!.neighbors {
      let neighborNode = edge.neighbor
      q.enqueue(neighborNode)

      print(neighborNode.label)
    }
  }
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

breadthFirstSearch(graph, root: nodeA)
