// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

func depthFirstSearch(_ digraph: Digraph, source: Node) -> [String] {
    var nodesExplored = [source.label]
    source.visited = true
    
    for edge in source.neighbors {
        if !edge.neighbor.visited {
            nodesExplored += depthFirstSearch(digraph, source: edge.neighbor)
        }
    }
    return nodesExplored
}

let digraph = Digraph()

let nodeA = digraph.addNode("a")
let nodeB = digraph.addNode("b")
let nodeC = digraph.addNode("c")
let nodeD = digraph.addNode("d")
let nodeE = digraph.addNode("e")
let nodeF = digraph.addNode("f")
let nodeG = digraph.addNode("g")
let nodeH = digraph.addNode("h")

digraph.addEdge(nodeA, neighbor: nodeB)
digraph.addEdge(nodeA, neighbor: nodeC)
digraph.addEdge(nodeB, neighbor: nodeD)
digraph.addEdge(nodeB, neighbor: nodeE)
digraph.addEdge(nodeC, neighbor: nodeF)
digraph.addEdge(nodeC, neighbor: nodeG)
digraph.addEdge(nodeE, neighbor: nodeH)
digraph.addEdge(nodeE, neighbor: nodeF)
digraph.addEdge(nodeF, neighbor: nodeG)

let nodesExplored = depthFirstSearch(digraph, source: nodeA)
print(nodesExplored)
