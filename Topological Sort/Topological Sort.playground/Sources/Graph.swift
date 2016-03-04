
public class Graph: CustomStringConvertible {
  
  private var adjacencyLists: [String : [String]]

  public init() {
    adjacencyLists = [String : [String]]()
  }
  
  public func addNode(value: String) -> String {
    adjacencyLists[value] = []
    return value
  }
  
  public func addEdge(fromNode from: String, toNode to: String) -> Bool {
    adjacencyLists[from]?.append(to)
    return adjacencyLists[from] != nil ? true : false
  }
  
  public var description: String {
    return adjacencyLists.description
  }
  
  private func adjacencyList(forValue: String) -> [String]? {
    for (key, adjacencyList) in adjacencyLists {
      if key == forValue {
        return adjacencyList
      }
    }
    return nil
  }
}

extension Graph {

  public func depthFirstSearch(source: String) -> [String] {
    var result = [String]()
    var stack = Stack<String>()
    
    result.append(source)
    stack.push(source)
    
    while !stack.isEmpty {
      if let element = stack.pop(), temp = adjacencyList(element) {
        for node in temp {
          stack.push(node)
          result.append(node)
        }
      }
    }
    
    return result
  }
}


