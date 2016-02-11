public class Graph {
  private var canvas: Array<Node>

  init() {
    canvas = Array<Node>()
  }

  func addNode(key: String) -> Node {
    let childNode: Node = Node(key: key)
    canvas.append(childNode)
    return childNode
  }

  func addEdge(source: Node, neighbor: Node) {
    let newEdge = Edge(neighbor: neighbor)
    newEdge.neighbor = neighbor
    source.neighbors.append(newEdge)
  }
}

public class Node {
  var key: String
  var neighbors: Array<Edge>

  init(key: String) {
    self.key = key
    self.neighbors = Array<Edge>()
  }
}

public class Edge {
  var neighbor: Node
  init(neighbor: Node) {
    self.neighbor = neighbor
  }
}

public class Queue<T> {
  private var top: QueueNode<T>! = QueueNode<T>()

  func enQueue(key: T) {
    if (top == nil) {
      top = QueueNode<T>()
    }

    if (top.key == nil) {
      top.key = key;
      return
    }

    let childToUse: QueueNode<T> = QueueNode<T>()
    var current: QueueNode = top
    while (current.next != nil) {
      current = current.next!
    }

    childToUse.key = key;
    current.next = childToUse;
  }

  func deQueue() -> QueueNode<T> {
    let itemToDeQueue = top
    top = itemToDeQueue.next
    return itemToDeQueue
  }

  var isEmpty: Bool {
    get { return top == nil }
  }
}

class QueueNode<T> {
  var key: T?
  var next: QueueNode?
}

func breadthFirstSearch(graph: Graph, root: Node) {

  let q = Queue<Node>()
  q.enQueue(root)
  print(root.key)

  while !q.isEmpty {
    let current = q.deQueue()
    for edge in current.key!.neighbors {
      let neighbor = edge.neighbor
      q.enQueue(neighbor)

      print(neighbor.key)
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
