# Topological Sort

Topological sort is an algorithm aimed at ordering a directed graph such that for each directed edge *uv* from vertex *u* to vertex *v*, *u* comes before *v*.

## Where is this used?

Let's consider that you want to learn all the algorithms present in the swift-algorithm-club, this might seem daunting at first but  we can use topological sort to get things organized.

For e.g. To learn the depth first search algorithm you need to know how a graph is represented. Similarly, to understand how to calculate the length of a binary tree you need to know details of how a tree is traversed. If we were to represent these in the form of a graph it would be as follows:

//add image

If we consider each algorithm to be a node in the graph you'll see dependancies among them i.e. to learn something you might have to know something else first. This is exactly what topological sort is used for, it will sort things out such that you know what to learn first.

## How does it work?

### Step 1: Find all nodes that have in-degree of 0

The in-degree of a node is the number of incoming edges to that node. All nodes that have no incoming edges have an in-degree of 0. These nodes are the starting points for the sort.

If you think about it in the context of the previous example these nodes represent algorithms that don't need anything else to be learnt, hence the sort starts with them.

### Step 2: Use depth first search for traversal

Depth first search is an algorithm that is used to traverse a graph. This algorithm traverses all the child nodes recursively and uses backtracking to find other edges.

To know more about this algorithm please take a look at the explanation here.

### Step 3: Remember all visited nodes

The last step of the sort is to maintain a list of all the nodes that have already been visited.

## Example

Consider the following graph:

*Step 1* Nodes with 0 in-degree: **5, 7, 3**
*Step 2* Depth first search for each without remembering nodes that have already been visited:

Node 3: 3, 8, 9, 10
Node 7: 7, 11, 2, 8, 9
Node 5: 5, 11, 2, 9, 10

*Step 3* Remember nodes already visited in each DFS.

Node 3: 3, 8, 9, 10
Node 7: 7, 11, 2
Node 5: 5

The final sorted order is a concatenation of the above three traversals: **3, 8, 9, 10, 7, 11, 2, 5**
