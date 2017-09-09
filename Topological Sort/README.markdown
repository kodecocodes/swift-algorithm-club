# Topological Sort

Topological sort is an algorithm that orders a directed graph such that for each directed edge *u→v*, vertex *u* comes before vertex *v*.

In other words, a topological sort places the vertices of a [directed acyclic graph](../Graph/) on a line so that all directed edges go from left to right. 

Consider the graph in the following example:

![Example](Images/Graph.png)

This graph has two possible topological sorts:

![Example](Images/TopologicalSort.png)

The topological orderings are **S, V, W, T, X** and **S, W, V, T, X**. Notice how the arrows all go from left to right.

The following is not a valid topological sort for this graph, since **X** and **T** cannot happen before **V**:

![Example](Images/InvalidSort.png)

## Where is this used?

Let's consider that you want to learn all the algorithms and data structures from the Swift Algorithm Club. This might seem daunting at first but we can use topological sort to get things organized.

Since you're learning about topological sort, let's take this topic as an example. What else do you need to learn first before you can fully understand topological sort? Well, topological sort uses [depth-first search](../Depth-First%20Search/) as well as a [stack](../Stack/). But before you can learn about the depth-first search algorithm, you need to know what a [graph](../Graph/) is, and it helps to know what a [tree](../Tree/) is. In turn, graphs and trees use the idea of linking objects together, so you may need to read up on that first. And so on...

If we were to represent these objectives in the form of a graph it would look as follows:

![Example](Images/Algorithms.png)

If we consider each algorithm to be a vertex in the graph you can clearly see the dependencies between them. To learn something you might have to know something else first. This is exactly what topological sort is used for -- it will sort things out so that you know what to do first.

## How does it work?

**Step 1: Find all vertices that have in-degree of 0**

The *in-degree* of a vertex is the number of edges pointing at that vertex. Vertices with no incoming edges have an in-degree of 0. These vertices are the starting points for the topological sort.

In the context of the previous example, these starting vertices represent algorithms and data structures that don't have any prerequisites; you don't need to learn anything else first, hence the sort starts with them.

**Step 2: Traverse the graph with depth-first search**

Depth-first search is an algorithm that starts traversing the graph from a certain vertex and explores as far as possible along each branch before backtracking. To find out more about depth-first search, please take a look at the [detailed explanation](../Depth-First%20Search/).

We perform a depth-first search on each vertex with in-degree 0. This tells us which vertices are connected to each of these starting vertices.

**Step 3: Remember all visited vertices**

As we perform the depth-first search, we maintain a list of all the vertices that have been visited. This is to avoid visiting the same vertex twice.

**Step 4: Put it all together**

The last step of the sort is to combine the results of the different depth-first searches and put the vertices in a sorted list.

## Example

Consider the following graph:

![Graph Example](Images/Example.png)

**Step 1:** The vertices with 0 in-degree are: **3, 7, 5**. These are our starting vertices.

**Step 2:** Perform depth-first search for each starting vertex, without remembering vertices that have already been visited:

```
Vertex 3: 3, 10, 8, 9
Vertex 7: 7, 11, 2, 8, 9
Vertex 5: 5, 11, 2, 9, 10
```

**Step 3:** Filter out the vertices already visited in each previous search:

```
Vertex 3: 3, 10, 8, 9
Vertex 7: 7, 11, 2
Vertex 5: 5
```

**Step 4:** Combine the results of these three depth-first searches. The final sorted order is **5, 7, 11, 2, 3, 10, 8, 9**. (Important: we need to add the results of each subsequent search to the *front* of the sorted list.)

The result of the topological sort looks like this:

![Result of the sort](Images/GraphResult.png)

> **Note:** This is not the only possible topological sort for this graph. For example, other valid solutions are **3, 7, 5, 10, 8, 11, 9, 2** and **3, 7, 5, 8, 11, 2, 9, 10**. Any order where all the arrows are going from left to right will do. 

## The code

Here is how you could implement topological sort in Swift (see also [TopologicalSort1.swift](TopologicalSort1.swift)):

```swift
extension Graph {
  public func topologicalSort() -> [Node] {
    // 1
    let startNodes = calculateInDegreeOfNodes().filter({ _, indegree in
      return indegree == 0
    }).map({ node, indegree in
      return node
    })
    
    // 2
    var visited = [Node : Bool]()
    for (node, _) in adjacencyLists {
      visited[node] = false
    }
    
    // 3
    var result = [Node]()
    for startNode in startNodes {
      result = depthFirstSearch(startNode, visited: &visited) + result
    }

    // 4    
    return result
  }
}
```

Some remarks:

1. Find the in-degree of each vertex and put all the vertices with in-degree 0 in the `startNodes` array. In this graph implementation, vertices are called "nodes". Both terms are used interchangeably by people who write graph code.

2. The `visited` array keeps track of whether we've already seen a vertex during the depth-first search. Initially, we set all elements to `false`.

3. For each of the vertices in the `startNodes` array, perform a depth-first search. This returns an array of sorted `Node` objects. We prepend that array to our own `result` array.

4. The `result` array contains all the vertices in topologically sorted order.

> **Note:** For a slightly different implementation of topological sort using depth-first search, see [TopologicalSort3.swift](TopologicalSort3.swift). This uses a stack and does not require you to find all vertices with in-degree 0 first.

## Kahn's algorithm

Even though depth-first search is the typical way to perform a topological sort, there is another algorithm that also does the job. 

1. Find out what the in-degree is of every vertex.
2. Put all the vertices that have no predecessors in a new array called `leaders`. These vertices have in-degree 0 and therefore do not depend on any other vertices.
3. Go through this list of leaders and remove them one-by-one from the graph. We don't actually modify the graph, we just decrement the in-degree of the vertices they point to. That has the same effect.
4. Look at the (former) immediate neighbor vertices of each leader. If any of them now have an in-degree of 0, then they no longer have any predecessors themselves. We'll add those vertices to the `leaders` array too.
5. This repeats until there are no more vertices left to look at. At this point, the `leaders` array contains all the vertices in sorted order.

This is an **O(n + m)** algorithm where **n** is the number of vertices and **m** is the number of edges. You can see the implementation in [TopologicalSort2.swift](TopologicalSort2.swift).

Source: I first read about this alternative algorithm in the Algorithm Alley column in Dr. Dobb's Magazine from May 1993.

*Written for Swift Algorithm Club by Ali Hafizji and Matthijs Hollemans*
