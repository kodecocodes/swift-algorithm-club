![Swift Algorithm Club](Images/SwiftAlgorithm-410-transp.png)

# Welcome to the Swift Algorithm Club!

Here you'll find implementations of popular algorithms and data structures in everyone's favorite new language Swift, with detailed explanations of how they work.

If you're a computer science student who needs to learn this stuff for exams -- or if you're a self-taught programmer who wants to brush up on the theory behind your craft -- you've come to the right place!

The goal of this project is to **explain how algorithms work**. The focus is on clarity and readability of the code, not on making a reusable library that you can drop into your own projects. That said, most of the code should be ready for production use but you may need to tweak it to fit into your own codebase.

Code is compatible with **Xcode 10** and **Swift 4.2**. We'll keep this updated with the latest version of Swift. If you're interested in a GitHub pages version of the repo, check out [this](https://aquarchitect.github.io/swift-algorithm-club/).

:heart_eyes: **Suggestions and contributions are welcome!** :heart_eyes:

## Important links

[What are algorithms and data structures?](What%20are%20Algorithms.markdown) Pancakes!

[Why learn algorithms?](Why%20Algorithms.markdown) Worried this isn't your cup of tea? Then read this.

[Big-O notation](Big-O%20Notation.markdown). We often say things like, "This algorithm is **O(n)**." If you don't know what that means, read this first.

[Algorithm design techniques](Algorithm%20Design.markdown). How do you create your own algorithms?

[How to contribute](https://github.com/raywenderlich/swift-algorithm-club/blob/master/.github/CONTRIBUTING.md). Report an issue to leave feedback, or submit a pull request.

## Where to start?

If you're new to algorithms and data structures, here are a few good ones to start out with:

- [Stack](Stack/)
- [Queue](Queue/)
- [Insertion Sort](Insertion%20Sort/)
- [Binary Search](Binary%20Search/) and [Binary Search Tree](Binary%20Search%20Tree/)
- [Merge Sort](Merge%20Sort/)
- [Boyer-Moore string search](Boyer-Moore-Horspool/)

## The algorithms

### Searching

- [Linear Search](Linear%20Search/). Find an element in an array.
- [Binary Search](Binary%20Search/). Quickly find elements in a sorted array.
- [Count Occurrences](Count%20Occurrences/). Count how often a value appears in an array.
- [Select Minimum / Maximum](Select%20Minimum%20Maximum). Find the minimum/maximum value in an array.
- [k-th Largest Element](Kth%20Largest%20Element/). Find the *k*-th largest element in an array, such as the median.
- [Selection Sampling](Selection%20Sampling/). Randomly choose a bunch of items from a collection.
- [Union-Find](Union-Find/). Keeps track of disjoint sets and lets you quickly merge them.


### String Search

- [Brute-Force String Search](Brute-Force%20String%20Search/). A naive method.
- [Boyer-Moore](Boyer-Moore-Horspool/). A fast method to search for substrings. It skips ahead based on a look-up table, to avoid looking at every character in the text.
- [Knuth-Morris-Pratt](Knuth-Morris-Pratt/). A linear-time string algorithm that returns indexes of all occurrencies of a given pattern.
- [Rabin-Karp](Rabin-Karp/)  Faster search by using hashing.
- [Longest Common Subsequence](Longest%20Common%20Subsequence/). Find the longest sequence of characters that appear in the same order in both strings.
- [Z-Algorithm](Z-Algorithm/). Finds all instances of a pattern in a String, and returns the indexes of where the pattern starts within the String.

### Sorting

It's fun to see how sorting algorithms work, but in practice you'll almost never have to provide your own sorting routines. Swift's own `sort()` is more than up to the job. But if you're curious, read on...

Basic sorts:

- [Insertion Sort](Insertion%20Sort/)
- [Selection Sort](Selection%20Sort/)
- [Shell Sort](Shell%20Sort/)

Fast sorts:

- [Quicksort](Quicksort/)
- [Merge Sort](Merge%20Sort/)
- [Heap Sort](Heap%20Sort/)

Hybrid sorts:

- [Introsort](Introsort/)

Special-purpose sorts:

- [Counting Sort](Counting%20Sort/)
- [Radix Sort](Radix%20Sort/)
- [Topological Sort](Topological%20Sort/)

Bad sorting algorithms (don't use these!):

- [Bubble Sort](Bubble%20Sort/)
- [Slow Sort](Slow%20Sort/)

### Compression

- [Run-Length Encoding (RLE)](Run-Length%20Encoding/). Store repeated values as a single byte and a count.
- [Huffman Coding](Huffman%20Coding/). Store more common elements using a smaller number of bits.

### Miscellaneous

- [Shuffle](Shuffle/). Randomly rearranges the contents of an array.
- [Comb Sort](Comb%20Sort/). An improve upon the Bubble Sort algorithm.
- [Convex Hull](Convex%20Hull/).
- [Miller-Rabin Primality Test](Miller-Rabin%20Primality%20Test/). Is the number a prime number?
- [MinimumCoinChange](MinimumCoinChange/). A showcase for dynamic programming.
- [Genetic](Genetic/). A simple example on how to slowly mutate a value to its ideal form, in the context of biological evolution.
- [Myers Difference Algorithm](Myers%20Difference%20Algorithm/). Finding the longest common subsequence of two sequences.
### Mathematics

- [Greatest Common Divisor (GCD)](GCD/). Special bonus: the least common multiple.
- [Permutations and Combinations](Combinatorics/). Get your combinatorics on!
- [Shunting Yard Algorithm](Shunting%20Yard/). Convert infix expressions to postfix.
- [Karatsuba Multiplication](Karatsuba%20Multiplication/). Another take on elementary multiplication.
- [Haversine Distance](HaversineDistance/). Calculating the distance between 2 points from a sphere.
- [Strassen's Multiplication Matrix](Strassen%20Matrix%20Multiplication/). Efficient way to handle matrix multiplication.

### Machine learning

- [k-Means Clustering](K-Means/). Unsupervised classifier that partitions data into *k* clusters.
- k-Nearest Neighbors
- [Linear Regression](Linear%20Regression/). A technique for creating a model of the relationship between two (or more) variable quantities.
- Logistic Regression
- Neural Networks
- PageRank
- [Naive Bayes Classifier](Naive%20Bayes%20Classifier/)
- [Simulated annealing](Simulated%20annealing/). Probabilistic technique for approximating the global maxima in a (often discrete) large search space.

## Data structures

The choice of data structure for a particular task depends on a few things.

First, there is the shape of your data and the kinds of operations that you'll need to perform on it. If you want to look up objects by a key you need some kind of dictionary; if your data is hierarchical in nature you want a tree structure of some sort; if your data is sequential you want a stack or queue.

Second, it matters what particular operations you'll be performing most, as certain data structures are optimized for certain actions. For example, if you often need to find the most important object in a collection, then a heap or priority queue is more optimal than a plain array.

Most of the time using just the built-in `Array`, `Dictionary`, and `Set` types is sufficient, but sometimes you may want something more fancy...

### Variations on arrays

- [Array2D](Array2D/). A two-dimensional array with fixed dimensions. Useful for board games.
- [Bit Set](Bit%20Set/). A fixed-size sequence of *n* bits.
- [Fixed Size Array](Fixed%20Size%20Array/). When you know beforehand how large your data will be, it might be more efficient to use an old-fashioned array with a fixed size.
- [Ordered Array](Ordered%20Array/). An array that is always sorted.
- [Rootish Array Stack](Rootish%20Array%20Stack/). A space and time efficient variation on Swift arrays.

### Queues

- [Stack](Stack/). Last-in, first-out!
- [Queue](Queue/). First-in, first-out!
- [Deque](Deque/). A double-ended queue.
- [Priority Queue](Priority%20Queue). A queue where the most important element is always at the front.
- [Ring Buffer](Ring%20Buffer/). Also known as a circular buffer. An array of a certain size that conceptually wraps around back to the beginning.

### Lists

- [Linked List](Linked%20List/). A sequence of data items connected through links. Covers both singly and doubly linked lists.
- [Skip-List](Skip-List/). Skip List is a probabilistic data-structure with same logarithmic time bound and efficiency as AVL/ or Red-Black tree and provides a clever compromise to efficiently support search and update operations.

### Trees

- [Tree](Tree/). A general-purpose tree structure.
- [Binary Tree](Binary%20Tree/). A tree where each node has at most two children.
- [Binary Search Tree (BST)](Binary%20Search%20Tree/). A binary tree that orders its nodes in a way that allows for fast queries.
- [Red-Black Tree](Red-Black%20Tree/). A self balancing binary search tree.
- [Splay Tree](Splay%20Tree/). A self balancing binary search tree that enables fast retrieval of recently updated elements.
- [Threaded Binary Tree](Threaded%20Binary%20Tree/). A binary tree that maintains a few extra variables for cheap and fast in-order traversals.
- [Segment Tree](Segment%20Tree/). Can quickly compute a function over a portion of an array.
  - [Lazy Propagation](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Segment%20Tree/LazyPropagation)
- kd-Tree
- [Sparse Table](Sparse%20Table/). Another take on quickly computing a function over a portion of an array, but this time we'll make it even quicker!.
- [Heap](Heap/). A binary tree stored in an array, so it doesn't use pointers. Makes a great priority queue.
- Fibonacci Heap
- [Trie](Trie/). A special type of tree used to store associative data structures.
- [B-Tree](B-Tree/). A self-balancing search tree, in which nodes can have more than two children.
- [QuadTree](QuadTree/). A tree with 4 children.
- [Octree](Octree/). A tree with 8 children.

### Hashing

- [Hash Table](Hash%20Table/). Allows you to store and retrieve objects by a key. This is how the dictionary type is usually implemented.
- Hash Functions

### Sets

- [Bloom Filter](Bloom%20Filter/). A constant-memory data structure that probabilistically tests whether an element is in a set.
- [Hash Set](Hash%20Set/). A set implemented using a hash table.
- [Multiset](Multiset/). A set where the number of times an element is added matters. (Also known as a bag.)
- [Ordered Set](Ordered%20Set/). A set where the order of items matters.

### Graphs

- [Graph](Graph/)
- [Breadth-First Search (BFS)](Breadth-First%20Search/)
- [Depth-First Search (DFS)](Depth-First%20Search/)
- [Shortest Path](Shortest%20Path%20%28Unweighted%29/) on an unweighted tree
- [Single-Source Shortest Paths](Single-Source%20Shortest%20Paths%20(Weighted)/)
- [Minimum Spanning Tree](Minimum%20Spanning%20Tree%20%28Unweighted%29/) on an unweighted tree
- [Minimum Spanning Tree](Minimum%20Spanning%20Tree/)
- [All-Pairs Shortest Paths](All-Pairs%20Shortest%20Paths/)
- [Dijkstra's shortest path algorithm](Dijkstra%20Algorithm/)

## Puzzles

A lot of software developer interview questions consist of algorithmic puzzles. Here is a small selection of fun ones. For more puzzles (with answers), see [here](http://elementsofprogramminginterviews.com/) and [here](http://www.crackingthecodinginterview.com).

- [Two-Sum Problem](Two-Sum%20Problem/)
- [Three-Sum/Four-Sum Problem](3Sum%20and%204Sum/)
- [Fizz Buzz](Fizz%20Buzz/)
- [Monty Hall Problem](Monty%20Hall%20Problem/)
- [Finding Palindromes](Palindromes/)
- [Dining Philosophers](DiningPhilosophers/)
- [Egg Drop Problem](Egg%20Drop%20Problem/)
- [Encoding and Decoding Binary Tree](Encode%20and%20Decode%20Tree/)
- [Closest Pair](Closest%20Pair/)

## Learn more!

Like what you see? Check out [Data Structures & Algorithms in Swift](https://store.raywenderlich.com/products/data-structures-and-algorithms-in-swift), the official book by the Swift Algorithm Club team!

![Data Structures & Algorithms in Swift Book](Images/DataStructuresAndAlgorithmsInSwiftBook.png)

You’ll start with the fundamental structures of linked lists, queues and stacks, and see how to implement them in a highly Swift-like way. Move on to working with various types of trees, including general purpose trees, binary trees, AVL trees, binary search trees, and tries. 

Go beyond bubble and insertion sort with better-performing algorithms, including mergesort, radix sort, heap sort, and quicksort. Learn how to construct directed, non-directed and weighted graphs to represent many real-world models, and traverse graphs and trees efficiently with breadth-first, depth-first, Dijkstra’s and Prim’s algorithms to solve problems such as finding the shortest path or lowest cost in a network.

By the end of this book, you’ll have hands-on experience solving common issues with data structures and algorithms — and you’ll be well on your way to developing your own efficient and useful implementations!

You can find the book on the [raywenderlich.com store](https://store.raywenderlich.com/products/data-structures-and-algorithms-in-swift).

## Credits

The Swift Algorithm Club was originally created by [Matthijs Hollemans](https://github.com/hollance).

It is now maintained by [Vincent Ngo](https://www.raywenderlich.com/u/jomoka), [Kelvin Lau](https://github.com/kelvinlauKL), and [Richard Ash](https://github.com/richard-ash).

The Swift Algorithm Club is a collaborative effort from the [most algorithmic members](https://github.com/raywenderlich/swift-algorithm-club/graphs/contributors) of the [raywenderlich.com](https://www.raywenderlich.com) community. We're always looking for help - why not [join the club](.github/CONTRIBUTING.md)? :]

## License

All content is licensed under the terms of the MIT open source license.

By posting here, or by submitting any pull request through this forum, you agree that all content you submit or create, both code and text, is subject to this license.  Razeware, LLC, and others will have all the rights described in the license regarding this content.  The precise terms of this license may be found [here](https://github.com/raywenderlich/swift-algorithm-club/blob/master/LICENSE.txt).

[![Build Status](https://travis-ci.org/raywenderlich/swift-algorithm-club.svg?branch=master)](https://travis-ci.org/raywenderlich/swift-algorithm-club)
