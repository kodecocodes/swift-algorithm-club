![Swift Algorithm Club](/Images/SwiftAlgorithm-410-transp.png)

[English](README.markdown)

# 欢迎来到 Swift 算法俱乐部！

在这里可以找到用大家最喜欢的新语言 Swift 实现的常见的算法和数据结构的实现，并且有这些算法和数据结构是如何工作的细节展示。

如果你是一个计算机系的学生，需要学习算法和数据结构来应付考试，又或者你是一个自学变成的程序员，想要复习各种理论知识，那么你来对地方了！

这个项目的目的是**揭示算法是如何工作的**。我们将重点关注代码的清晰度和可读性，而不会做一个可以直接添加到你工程里的复用库。也就是说，大部分的代码是为了展示用的，想要使用就要在自己代码的基础上进行调整。

大部分的代码是兼容**Xcode 8.2** 和**Swift3**的。我们会持续更新以便与最新的 Swift 兼容。

这是一个持续的工作。陆续会有更多的算法加进来。:-)

:heart_eyes: **欢迎提出建议和做贡献!** :heart_eyes:

## 重要链接

[什么是算法和数据结构?](What are Algorithms-CN.markdown) 薄煎饼!

[为什么学习算法？](Why Algorithms-CN.markdown) 还在担心这不是你的菜吗？看看这个吧

[大 O 表示法](Big-O Notation-CN.markdown)。 我们经常会说“这个算法是**O(n)**”。如果你不知道这是什么意思，读读这篇吧。

[算法设计技巧](Algorithm Design-CN.markdown)。怎样设计自己的算法？

[如何做贡献](How to Contribute-CN.markdown)。报告问题或者提交 pull 请求

[构建中](Under Construction.markdown)。 还没有实现的算法

## 从哪里开始

如果你是一个新手，下面的文章是一个很好的开始：

- [栈](Stack/README-CN.markdown)
- [队列](Queue/README-CN.markdown)
- [插入排序](Insertion Sort/README-CN.markdown)
- [二分搜索](Binary Search/README-CN.markdown) 和 [二叉搜索树](Binary Search Tree/README-CN.markdown)
- [归并排序](Merge Sort/README-CN.markdown)
- [Boyer-Moore 字符串搜索](Boyer-Moore/README-CN.markdown)

## 算法

### 搜索

- [线性搜索](Linear Search/)。 在数组中查找一个元素
- [二分搜索](Binary Search/README-CN.markdown)。 在有序数组中快速查找元素。
- [计算出现频率](Count Occurrences/README-CN.markdown)。统计值在数组中出现的频率
- [查找最大/最小值](Select Minimum Maximum/README-CN.markdown)。 查找数组中的最大最小值
- [第 k 大的元素](Kth Largest Element/README-CN.markdown)。找到数组中第*k*大的元素，比如中间值。
- [选取样本](Selection Sampling/README-CN.markdown)。 从集合中随机选择一些样本
- [联合查找](Union-Find/README-CN.markdown)。 跟踪不相交的集合并且快速合并它们

### 字符串搜索

- [Brute-Force String Search](Brute-Force String Search/). A naive method.
- [Boyer-Moore](Boyer-Moore/README-CN.markdown)。一个快速搜索子字符串的方法。它基于一个查询表来跳过一些字符来避免查找文本中的每个字符。
- Knuth-Morris-Pratt
- [Rabin-Karp](Rabin-Karp/)  Faster search by using hashing.
- [Longest Common Subsequence](Longest Common Subsequence/). Find the longest sequence of characters that appear in the same order in both strings.
- [Z-Algorithm](Z-Algorithm/). Finds all instances of a pattern in a String, and returns the indexes of where the pattern starts within the String.

### 排序

看排序算法是如何工作的是很有意思的，但在实际中却几乎不可能用自己的排序程序。Swift 自己的 `sor()` 已经可以满足工作了，但是如果你好奇的话，请继续阅读吧...

基本排序:

- [插入排序](Insertion Sort/README-CN.markdown)
- [选择排序](Selection Sort/README-CN.markdown)
- [希尔排序](Shell Sort/README-CN.markdown)

快速排序:

- [快速排序](Quicksort/README-CN.markdown)
- [归并排序](Merge Sort/README-CN.markdown)
- [堆排序](Heap Sort/README-CN.markdown)

特殊目的的排序:

- [计数排序](Counting Sort/README-CN.markdown)
- Radix Sort
- [拓扑排序](Topological Sort/README-CN.markdown)

糟糕的排序算法 (不要用它们!):

- [冒泡排序](Bubble Sort/README-CN.markdown)
- [慢排序](Slow Sort/README-CN.markdown)

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
- [Karatsuba Multiplication](Karatsuba Multiplication/). Another take on elementary multiplication.
- [Haversine Distance](HaversineDistance/). Calculating the distance between 2 points from a sphere.

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
- [Rootish Array Stack](Rootish Array Stack/). A space and time efficient variation on Swift arrays.

### 队列

- [栈](Stack/README-CN.markdown)。 后进先出！
- [队列](Queue/README-CN.markdown)。 先进先出！
- [Deque](Deque/). A double-ended queue.
- [Priority Queue](Priority Queue). A queue where the most important element is always at the front.
- [Ring Buffer](Ring Buffer/). Also known as a circular buffer. An array of a certain size that conceptually wraps around back to the beginning.

### Lists

- [Linked List](Linked List/). A sequence of data items connected through links. Covers both singly and doubly linked lists.
- [Skip-List](Skip-List/). Skip List is a probablistic data-structure with same logarithmic time bound and efficiency as AVL/ or Red-Black tree and provides a clever compromise to efficiently support search and update operations.

### Trees

- [Tree](Tree/). A general-purpose tree structure.
- [Binary Tree](Binary Tree/). A tree where each node has at most two children.
- [二叉搜索树 (BST)](Binary Search Tree/README-CN.markdown). A binary tree that orders its nodes in a way that allows for fast queries.
- Red-Black Tree
- Splay Tree
- Threaded Binary Tree
- [Segment Tree](Segment Tree/). Can quickly compute a function over a portion of an array.
- kd-Tree
- [Heap](Heap/). A binary tree stored in an array, so it doesn't use pointers. Makes a great priority queue.
- Fibonacci Heap
- [Trie](Trie/). A special type of tree used to store associative data structures.
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
- [Dining Philosophers](DiningPhilosophers/)

## Learn more!

For more information, check out these great books:

- [Introduction to Algorithms](https://mitpress.mit.edu/books/introduction-algorithms) by Cormen, Leiserson, Rivest, Stein
- [The Algorithm Design Manual](http://www.algorist.com) by Skiena
- [Elements of Programming Interviews](http://elementsofprogramminginterviews.com) by Aziz, Lee, Prakash
- [Algorithms](http://www.cs.princeton.edu/~rs/) by Sedgewick
- [Grokking Algorithms](https://www.manning.com/books/grokking-algorithms) by Aditya Bhargava 

The following books are available for free online:

- [Algorithms](http://www.beust.com/algorithms.pdf) by Dasgupta, Papadimitriou, Vazirani
- [Algorithms, Etc.](http://jeffe.cs.illinois.edu/teaching/algorithms/) by Erickson
- [Algorithms + Data Structures = Programs](http://www.ethoberon.ethz.ch/WirthPubl/AD.pdf) by Wirth
- Algorithms and Data Structures: The Basic Toolbox by Mehlhorn and Sanders
- [Open Data Structures](http://opendatastructures.org) by Pat Morin
- [Wikibooks: Algorithms and Implementations](https://en.wikibooks.org/wiki/Algorithm_Implementation)

Other algorithm repositories:

- [EKAlgorithms](https://github.com/EvgenyKarkan/EKAlgorithms). A great collection of algorithms in Objective-C.
- [@lorentey](https://github.com/lorentey/). Production-quality Swift implementations of common algorithms and data structures.
- [Rosetta Code](http://rosettacode.org). Implementations in pretty much any language you can think of.
- [AlgorithmVisualizer](http://jasonpark.me/AlgorithmVisualizer/). Visualize algorithms on your browser.
- [Swift Structures](https://github.com/waynewbishop/SwiftStructures) Data Structures with directions on how to use them [here](http://waynewbishop.com/swift)

## Credits

The Swift Algorithm Club was originally created by [Matthijs Hollemans](https://github.com/hollance).

It is now maintained by [Vincent Ngo](https://www.raywenderlich.com/u/jomoka) and [Kelvin Lau](https://github.com/kelvinlauKL).

The Swift Algorithm Club is a collaborative effort from the [most algorithmic members](https://github.com/rwenderlich/swift-algorithm-club/graphs/contributors) of the [raywenderlich.com](https://www.raywenderlich.com) community. We're always looking for help - why not [join the club](How to Contribute.markdown)? :]

## License

All content is licensed under the terms of the MIT open source license.

By posting here, or by submitting any pull request through this forum, you agree that all content you submit or create, both code and text, is subject to this license.  Razeware, LLC, and others will have all the rights described in the license regarding this content.  The precise terms of this license may be found [here](https://github.com/raywenderlich/swift-algorithm-club/blob/master/LICENSE.txt).

[![Build Status](https://travis-ci.org/raywenderlich/swift-algorithm-club.svg?branch=master)](https://travis-ci.org/raywenderlich/swift-algorithm-club)


