public class Graph: CustomStringConvertible {
  public typealias Node = String
  
  private(set) public var adjacencyLists: [Node : [Node]]

  public init() {
    adjacencyLists = [Node : [Node]]()
  }
  
  public func addNode(value: Node) -> Node {
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
