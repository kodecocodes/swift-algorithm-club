![Swift Algorithm Club](/Images/SwiftAlgorithm-410-transp.png)

# Welcome to the Swift Algorithm Club!

Here you'll find implementations of popular algorithms and data structures in everyone's favorite new language Swift, with detailed explanations of how they work.

If you're a computer science student who needs to learn this stuff for exams -- or if you're a self-taught programmer who wants to brush up on the theory behind your craft -- you've come to the right place!

The goal of this project is to **explain how algorithms work**. The focus is on clarity and readability of the code, not on making a reusable library that you can drop into your own projects. That said, most of the code should be ready for production use but you may need to tweak it to fit into your own codebase.

All code is compatible with **Xcode 7.3** and **Swift 2.2**. We'll keep this updated with the latest version of Swift.

This is a work in progress. More algorithms will be added soon. :-) 

:heart_eyes: **Suggestions and contributions are welcome!** :heart_eyes:

## Important links

[What are algorithms and data structures?](What are Algorithms.markdown) Pancakes!

[Why learn algorithms?](Why Algorithms.markdown) Worried this isn't your cup of tea? Then read this.

[Big-O notation](Big-O Notation.markdown). We often say things like, "This algorithm is **O(n)**." If you don't know what that means, read this first.

[Algorithm design techniques](Algorithm Design.markdown). How do you create your own algorithms?

[How to contribute](How to Contribute.markdown). Report an issue to leave feedback, or submit a pull request.

[Under construction](Under Construction.markdown). Algorithms that are under construction. 

## Where to start?

If you're new to algorithms and data structures, here are a few good ones to start out with:

- [Stack](Stack/)
- [Queue](Queue/)
- [Insertion Sort](Insertion Sort/)
- [Binary Search](Binary Search/) and [Binary Search Tree](Binary Search Tree/)
- [Merge Sort](Merge Sort/)
- [Boyer-Moore string search](Boyer-Moore/)

## The algorithms

### Searching

- [Linear Search](Linear Search/). Find an element in an array.
- [Binary Search](Binary Search/). Quickly find elements in a sorted array.
- [Count Occurrences](Count Occurrences/). Count how often a value appears in an array.
- [Select Minimum / Maximum](Select Minimum Maximum). Find the minimum/maximum value in an array.
- [k-th Largest Element](Kth Largest Element/). Find the *k*-th largest element in an array, such as the median.
- [Selection Sampling](Selection Sampling/). Randomly choose a bunch of items from a collection.
- [Union-Find](Union-Find/). Keeps track of disjoint sets and lets you quickly merge them.

### String Search

- [Brute-Force String Search](Brute-Force String Search/). A naive method.
- [Boyer-Moore](Boyer-Moore/). A fast method to search for substrings. It skips ahead based on a look-up table, to avoid looking at every character in the text.
- Knuth-Morris-Pratt
- Rabin-Karp
- [Longest Common Subsequence](Longest Common Subsequence/). Find the longest sequence of characters that appear in the same order in both strings.

### Sorting

It's fun to see how sorting algorithms work, but in practice you'll almost never have to provide your own sorting routines. Swift's own `sort()` is more than up to the job. But if you're curious, read on...

Basic sorts:

- [Insertion Sort](Insertion Sort/)
- [Selection Sort](Selection Sort/)
- [Shell Sort](Shell Sort/)

Fast sorts:

- [Quicksort](Quicksort/)
- [Merge Sort](Merge Sort/)
- [Heap Sort](Heap Sort/)

Special-purpose sorts:

- [Counting Sort](Counting Sort/)
- Radix Sort
- [Topological Sort](Topological Sort/)

Bad sorting algorithms (don't use these!):

- [Bubble Sort](Bubble Sort/)

### Compression

- [Run-Length Encoding (RLE)](Run-Length Encoding/). Store repeated values as a single byte and a count.
- [Huffman Coding](Huffman Coding/). Store more common elements using a smaller number of bits.

### Miscellaneous

- [Shuffle](Shuffle/). Randomly rearranges the contents of an array.
- [Comb Sort](Comb Sort/). An improve upon the Bubble Sort algorithm.

### Mathematics

- [Greatest Common Divisor (GCD)](GCD/). Special bonus: the least common multiple.
- [Permutations and Combinations](Combinatorics/). Get your combinatorics on!
- [Shunting Yard Algorithm](Shunting Yard/). Convert infix expressions to postfix.
- Statistics

### Machine learning

- [k-Means Clustering](K-Means/). Unsupervised classifier that partitions data into *k* clusters.
- k-Nearest Neighbors
- [Linear Regression](Linear Regression/)
- Logistic Regression
- Neural Networks
- PageRank

## Data structures

The choice of data structure for a particular task depends on a few things.

First, there is the shape of your data and the kinds of operations that you'll need to perform on it. If you want to look up objects by a key you need some kind of dictionary; if your data is hierarchical in nature you want a tree structure of some sort; if your data is sequential you want a stack or queue.

Second, it matters what particular operations you'll be performing most, as certain data structures are optimized for certain actions. For example, if you often need to find the most important object in a collection, then a heap or priority queue is more optimal than a plain array.

Most of the time using just the built-in `Array`, `Dictionary`, and `Set` types is sufficient, but sometimes you may want something more fancy...

### Variations on arrays

- [Array2D](Array2D/). A two-dimensional array with fixed dimensions. Useful for board games.
- [Bit Set](Bit Set/). A fixed-size sequence of *n* bits.
- [Fixed Size Array](Fixed Size Array/). When you know beforehand how large your data will be, it might be more efficient to use an old-fashioned array with a fixed size.
- [Ordered Array](Ordered Array/). An array that is always sorted.

### Queues

- [Stack](Stack/). Last-in, first-out!
- [Queue](Queue/). First-in, first-out!
- [Deque](Deque/). A double-ended queue.
- [Priority Queue](Priority Queue). A queue where the most important element is always at the front.
- [Ring Buffer](Ring Buffer/). Also known as a circular buffer. An array of a certain size that conceptually wraps around back to the beginning.

### Lists

- [Linked List](Linked List/). A sequence of data items connected through links. Covers both singly and doubly linked lists.
- Skip List

### Trees

- [Tree](Tree/). A general-purpose tree structure.
- [Binary Tree](Binary Tree/). A tree where each node has at most two children.
- [Binary Search Tree (BST)](Binary Search Tree/). A binary tree that orders its nodes in a way that allows for fast queries.
- Red-Black Tree
- Splay Tree
- Threaded Binary Tree
- [Segment Tree](Segment Tree/). Can quickly compute a function over a portion of an array.
- kd-Tree
- [Heap](Heap/). A binary tree stored in an array, so it doesn't use pointers. Makes a great priority queue.
- Fibonacci Heap
- Trie
- [B-Tree](B-Tree/). A self-balancing search tree, in which nodes can have more than two children.

### Hashing

- [Hash Table](Hash Table/). Allows you to store and retrieve objects by a key. This is how the dictionary type is usually implemented.
- Hash Functions

### Sets

- [Bloom Filter](Bloom Filter/). A constant-memory data structure that probabilistically tests whether an element is in a set.
- [Hash Set](Hash Set/). A set implemented using a hash table.
- Multiset
- [Ordered Set](Ordered Set/). A set where the order of items matters.

### Graphs

- [Graph](Graph/)
- [Breadth-First Search (BFS)](Breadth-First Search/)
- [Depth-First Search (DFS)](Depth-First Search/)
- [Shortest Path](Shortest Path %28Unweighted%29/) on an unweighted tree
- [Single-Source Shortest Paths](Single-Source Shortest Paths (Weighted)/)
- [Minimum Spanning Tree](Minimum Spanning Tree %28Unweighted%29/) on an unweighted tree
- [All-Pairs Shortest Paths](All-Pairs Shortest Paths/)

## Puzzles

A lot of software developer interview questions consist of algorithmic puzzles. Here is a small selection of fun ones. For more puzzles (with answers), see [here](http://elementsofprogramminginterviews.com/) and [here](http://www.crackingthecodinginterview.com).

- [Two-Sum Problem](Two-Sum Problem/)
- [Fizz Buzz](Fizz Buzz/)
- [Monty Hall Problem](Monty Hall Problem/)
- [Finding Palindromes](Palindromes/)

## Learn more!

For more information, check out these great books:

- [Introduction to Algorithms](https://mitpress.mit.edu/books/introduction-algorithms) by Cormen, Leiserson, Rivest, Stein
- [The Algorithm Design Manual](http://www.algorist.com) by Skiena
- [Elements of Programming Interviews](http://elementsofprogramminginterviews.com) by Aziz, Lee, Prakash
- [Algorithms](http://www.cs.princeton.edu/~rs/) by Sedgewick

The following books are available for free online:

- [Algorithms](http://www.beust.com/algorithms.pdf) by Dasgupta, Papadimitriou, Vazirani
- [Algorithms, Etc.](http://jeffe.cs.illinois.edu/teaching/algorithms/) by Erickson
- [Algorithms + Data Structures = Programs](http://www.ethoberon.ethz.ch/WirthPubl/AD.pdf) by Wirth
- Algorithms and Data Structures: The Basic Toolbox by Mehlhorn and Sanders
- [Wikibooks: Algorithms and Implementations](https://en.wikibooks.org/wiki/Algorithm_Implementation)

Other algorithm repositories:

- [EKAlgorithms](https://github.com/EvgenyKarkan/EKAlgorithms). A great collection of algorithms in Objective-C.
- [@lorentey](https://github.com/lorentey/). Production-quality Swift implementations of common algorithms and data structures.
- [Rosetta Code](http://rosettacode.org). Implementations in pretty much any language you can think of.
- [AlgorithmVisualizer](http://jasonpark.me/AlgorithmVisualizer/). Visualize algorithms on your browser.

## Credits

The Swift Algorithm Club was originally created by [Matthijs Hollemans](https://github.com/hollance).

It is now maintained by [Chris Pilcher](https://github.com/chris-pilcher) and [Kelvin Lau](https://github.com/kelvinlauKL).

The Swift Algorithm Club is a collaborative effort from the [most algorithmic members](https://github.com/rwenderlich/swift-algorithm-club/graphs/contributors) of the [raywenderlich.com](https://www.raywenderlich.com) community. We're always looking for help - why not [join the club](How to Contribute.markdown)? :]

## License

All content is licensed under the terms of the MIT open source license.

[![Build Status](https://travis-ci.org/raywenderlich/swift-algorithm-club.svg?branch=master)](https://travis-ci.org/raywenderlich/swift-algorithm-club)
