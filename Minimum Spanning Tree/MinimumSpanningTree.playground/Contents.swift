/**
 The following code demonstrates getting MST of the graph below by both
 Kruskal's and Prim's algorithms.
 */

func minimumSpanningTreeKruskal<T>(graph: Graph<T>) -> (cost: Int, tree: Graph<T>) {
    var cost: Int = 0
    var tree = Graph<T>()
    let sortedEdgeListByWeight = graph.edgeList.sorted(by: { $0.weight < $1.weight })
    
    var unionFind = UnionFind<T>()
    for vertex in graph.vertices {
        unionFind.addSetWith(vertex)
    }
    
    for edge in sortedEdgeListByWeight {
        let v1 = edge.vertex1
        let v2 = edge.vertex2
        if !unionFind.inSameSet(v1, and: v2) {
            cost += edge.weight
            tree.addEdge(edge)
            unionFind.unionSetsContaining(v1, and: v2)
        }
    }
    
    return (cost: cost, tree: tree)
}

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

/*:
 ![Graph](mst.png)
 */

var graph = Graph<Int>()
graph.addEdge(vertex1: 1, vertex2: 2, weight: 6)
graph.addEdge(vertex1: 1, vertex2: 3, weight: 1)
graph.addEdge(vertex1: 1, vertex2: 4, weight: 5)
graph.addEdge(vertex1: 2, vertex2: 3, weight: 5)
graph.addEdge(vertex1: 2, vertex2: 5, weight: 3)
graph.addEdge(vertex1: 3, vertex2: 4, weight: 5)
graph.addEdge(vertex1: 3, vertex2: 5, weight: 6)
graph.addEdge(vertex1: 3, vertex2: 6, weight: 4)
graph.addEdge(vertex1: 4, vertex2: 6, weight: 2)
graph.addEdge(vertex1: 5, vertex2: 6, weight: 6)

print("===== Kruskal's =====")
let result1 = minimumSpanningTreeKruskal(graph: graph)
print("Minimum spanning tree total weight: \(result1.cost)")
print("Minimum spanning tree:")
print(result1.tree)

print("===== Prim's =====")
let result2 = minimumSpanningTreePrim(graph: graph)
print("Minimum spanning tree total weight: \(result2.cost)")
print("Minimum spanning tree:")
print(result2.tree)
