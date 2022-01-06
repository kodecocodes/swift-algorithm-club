# Prim's Algorithm

Prim's Algorithm is an algorithm that finds a minimum spanning tree for a weighted undirected graph. This means it finds a subset of the edges that forms a tree that includes every vertex, where the total weight of all the edges in the tree is minimized.


## How does it work

We start from one vertex and keep adding edges with the lowest weight until we reach our goal. 
1. Initialize the minimum spanning tree with a vertex chosen at random
2. Find all the edges that connect the tree to new verticles, find the minimum and add it to the tree
3. Keep repeating step 2 until we get a minimum spanning tree

## Time complexity
Adjacency matrix, searching : O(|V|^{2})
binary heap and adjacency list : O((|V|+|E|)\log |V|)= O(|E|\log |V|)
Fibonacci heap and adjacency list : O(|E|+|V|\log |V|)

##Sources 

[1]: 
https://www.programiz.com/dsa/prim-algorithm
[2]:
https://www.raywenderlich.com/books/data-structures-algorithms-in-swift/v4.0/chapters/45-prim-s-algorithm-challenges
[3]: https://codereview.stackexchange.com/questions/215897/swift-prims-algorithm
