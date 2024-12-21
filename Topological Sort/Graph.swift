
/**
 *  A class that represents a graph data structure.
 *  It contains an adjacency list which is a dictionary of nodes and their corresponding edges.
 *  It has the following methods:
 *  - addNode(value: Node) -> Node: adds a new node to the graph
 *  - addEdge(fromNode: Node, toNode: Node) -> Bool: adds a directed edge from one node to another
 *  - adjacencyList(forNode: Node) -> [Node]? : returns the list of nodes that are adjacent to the given node
 *  - calculateInDegreeOfNodes() -> [Node : InDegree]: returns a dictionary of nodes and their corresponding in-degree values
 *
 */

public class Graph: CustomStringConvertible {
  public typealias Node = String

  private(set) public var adjacencyLists: [Node : [Node]]

  public init() {
    adjacencyLists = [Node: [Node]]()
  }

  public func addNode(_ value: Node) -> Node {
    adjacencyLists[value] = []
    return value
  }

  public func addEdge(fromNode from: Node, toNode to: Node) -> Bool {
    adjacencyLists[from]?.append(to)
    return adjacencyLists[from] != nil ? true : false
  }

  public var description: String {
    return adjacencyLists.description
  }

  public func adjacencyList(forNode node: Node) -> [Node]? {
    for (key, adjacencyList) in adjacencyLists {
      if key == node {
        return adjacencyList
      }
    }
    return nil
  }
}

extension Graph {
  typealias InDegree = Int
  
  /**
   *  A method that calculates the in-degree of all the nodes in the graph.
   *  It returns a dictionary with the nodes as keys and their corresponding in-degree values as values.
   *
   *  - returns: A dictionary of [Node : InDegree]
   */

  func calculateInDegreeOfNodes() -> [Node : InDegree] {
    var inDegrees = [Node: InDegree]()

    for (node, _) in adjacencyLists {
      inDegrees[node] = 0
    }

    for (_, adjacencyList) in adjacencyLists {
      for nodeInList in adjacencyList {
        inDegrees[nodeInList] = (inDegrees[nodeInList] ?? 0) + 1
      }
    }
    return inDegrees
  }
}
