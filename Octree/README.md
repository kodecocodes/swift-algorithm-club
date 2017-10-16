# OcTree

An octree is a [tree](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Tree) in which each internal (not leaf) node has eight children. Often used for collision detection in games for example.

### Problem

Consider the following problem: your need to store a number of objects in 3D space (each at a certain location with `X`, `Y` and `Z` coordinates) and then you need to answer which objects lie in a certain 3D region. A naive solution would be to store the points inside an array and then iterate over the points and check each one individually. This solution runs in O(n) though.

### A Better Approach

Octrees are most commonly used to partition a three-dimensional space by recursively subdividing it into 8 regions. Let's see how we can use an Octree to store some values.

Each node in the tree represents a box-like region. Leaf nodes store a single point in that region with an array of objects assigned to that point.

Once an object within the same region (but at a different point) is added the leaf node turns into an internal node and 8 child nodes (leaves) are added to it. All points previously contained in the node are passed to its corresponding children and stored. Thus only leaves contain actual points and values.

To find the points that lie in a given region we can now traverse the tree from top to bottom and collect the suitable points from nodes.

Both adding a point and searching can still take up to O(n) in the worst case, since the tree isn't balanced in any way. However, on average it runs significantly faster (something comparable to O(log n)).

### See also

More info on [Wiki](https://en.wikipedia.org/wiki/Octree)
Apple's implementation of [GKOctree](https://developer.apple.com/documentation/gameplaykit/gkoctree)

*Written for Swift Algorithm Club by Jaap Wijnen*
*Heavily inspired by Timur Galimov's Quadtree implementation and Apple's GKOctree implementation
