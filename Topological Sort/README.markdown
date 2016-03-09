# Topological Sort

Topological sort is an algorithm aimed at ordering a directed graph such that for each directed edge *uv* from vertex *u* to vertex *v*, *u* comes before *v*.

In other words, a topological sort places the vertices of a directed acyclic graph on a line so that all directed edges go from left to right. 

The graph in the following example has two possible topological sorts:

![Example](Images/TopologicalSort.png)

## Where is this used?

Let's consider that you want to learn all the algorithms present in the Swift Algorithm Club. This might seem daunting at first but  we can use topological sort to get things organized.

For example, to learn the [depth-first search](../Depth-First Search/) algorithm you need to know how a [graph](../Graph/) is represented. Similarly, to understand how to calculate the length of a [binary tree](../Binary Tree/) you need to know details of how a [tree is traversed](../Tree/).

If we were to represent these objectives in the form of a graph it would be as follows:

![Example](Images/algorithm_example.png)

If we consider each algorithm to be a node in the graph you'll see dependancies among them, i.e. to learn something you might have to know something else first. This is exactly what topological sort is used for -- it will sort things out such that you know what to learn first.

## How does it work?

**Step 1: Find all nodes that have in-degree of 0**

The *in-degree* of a node is the number of incoming edges to that node. Nodes that have no incoming edges have an in-degree of 0. These nodes are the starting points for the sort.

If you think about it in the context of the previous example, these nodes represent algorithms that don't have any prerequisites; you don't need to learn anything else first, hence the sort starts with them.

**Step 2: Depth-first search for traversal**

Depth-first search is an algorithm that is used to traverse a graph. This algorithm traverses all the child nodes recursively and uses backtracking.

To find out more about depth-first search, please take a look at the [detailed explanation](../Depth-First%20Search/).

**Step 3: Remember all visited nodes**

The last step of the sort is to maintain a list of all the nodes that have been visited. This is to avoid visiting the same node twice.

## Example

Consider the following graph:

![Graph Example](Images/graph_example.png)

**Step 1:** The nodes with 0 in-degree are: **5, 7, 3**

**Step 2:** Depth-first search for each starting node, without remembering nodes that have already been visited:

```
Node 3: 3, 8, 9, 10
Node 7: 7, 11, 2, 8, 9
Node 5: 5, 11, 2, 9, 10
```

**Step 3:** Remember nodes already visited in each DFS:

```
Node 3: 3, 8, 9, 10
Node 7: 7, 11, 2
Node 5: 5
```

The final sorted order is a concatenation of the above three traversals: **3, 8, 9, 10, 7, 11, 2, 5**

The result of the topological sort looks like this:

![Result of the sort](Images/GraphResult.png)

TODO: I don't think this is correct! There should be no arrows going from right to left! (A valid topological order would be 3, 7, 5, 10, 8, 11, 9, 2 -- or 3, 7, 5, 8, 11, 2, 9, 10.)


*Written for Swift Algorithm Club by Ali Hafizji*
