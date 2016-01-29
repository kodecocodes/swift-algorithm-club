# Swift Algorithm Club

Welcome to the algorithm club!

Here you'll find implementations of popular algorithms and data structures in everyone's favorite new language Swift, with detailed explanations of how they work.

If you're a computer science student who needs to learn this stuff for exams -- or if you're a self-taught programmer who wants to brush up on the theory behind your craft, you've come to the right place.

The goal of this project is to explain how algorithms work. The focus is on clarity and readability of the code, not on making a reusable library that you can drop into your own projects. That said, most of the code should be ready for production use, but you may need to tweak it to fit into your own codebase.

This is a work in progress. More algorithms will be added soon. :-)

**Suggestions and contributions are welcome!** Report an issue to leave feedback, or submit a pull request.

## Where to start?

If you're new to algorithms and data structures, here are a few good ones to start out with:

- [Stack](Stack/)
- [Queue](Queue/)
- [Insertion Sort](Insertion Sort/)
- [Binary Search](Binary Search/)
- Binary Tree
- Merge Sort
- [Boyer-Moore](Boyer-Moore/) string search

## The algorithms

### Searching

- [Linear Search](Linear Search/). Find an element in an array.
- [Binary Search](Binary Search/). Quickly find elements in a sorted array.
- [Count Occurrences](Count Occurrences/). Count how often a value appears in an array.
- Select Minimum / Maximum
- Select k-th Largest Element
- Selection Sampling
- Union-Find

### String Search

- [Boyer-Moore](Boyer-Moore/). A fast method to search for substrings. It skips ahead based on a look-up table, to avoid looking at every character in the text.
- Rabin-Karp

### Sorting

It's fun to see how sorting algorithms work, but in practice you'll almost never have to provide your own sorting routines. Swift's own `sort()` is more than up to the job. But if you're curious, read on...

Basic sorts:

- [Insertion Sort](Insertion Sort/)
- [Selection Sort](Selection Sort/)
- Shell Sort

Fast sorts:

- [Quicksort](Quicksort/)
- Merge Sort
- Heap Sort

Special-purpose sorts:

- Bucket Sort
- Counting Sort
- Radix Sort
- Topological Sort

Bad sorting algorithms (don't use these!):

- [Bubble Sort](Bubble Sort/)

### Compression

- Huffman Encoding

### Miscellaneous

- Shuffle array

### Mathematics

- Greatest Common Divisor (GCD)
- Statistics
- Combinatorics (permutations etc)

## Data structures

The choice of data structure for a particular task depends on a few things. 

First, there is the shape of your data and the kinds of operations that you'll need to perform on it. If you want to look up objects by a key you need some kind of dictionary; if your data is hierarchical in nature you want a tree structure of some sort; if your data is sequential you want a stack or queue.

Second, it matters what particular operations you'll be performing most, as certain data structures are optimized for certain actions. For example, if you often need to find the most important object in a queue, then a heap or priority queue is more optimal than a plain array.

Often just using the built-in `Array`, `Dictionary`, and `Set` types is sufficient, but sometimes you may want something more fancy...

### Variations on arrays

- [Array2D](Array2D/). A two-dimensional array with fixed dimensions. Useful for board games.
- [Fixed Size Array](Fixed Size Array/). When you know beforehand how large your data will be, it might be more efficient to use an array with a fixed size.
- Ordered Array. An array that is always sorted.
- Ring Buffer. Also known as a circular buffer. An array of a certain size that conceptually wraps around back to the beginning.

### Queues

- [Stack](Stack/). Last-in, first-out!
- [Queue](Queue/). First-in, first-out!
- Deque
- Priority Queue

### Lists

- Singly Linked List
- Doubly Linked List

### Trees

- Tree (general-purpose)
- Binary Tree
- Binary Search Tree (BST)
- AVL Tree
- Red-Black Tree
- Splay Tree
- Threaded Binary Tree
- kd-Tree
- [Heap](Heap/). A binary tree stored in an array, so it doesn't use pointers. Makes a great priority queue.
- Fibonacci Heap
- Trie

### Sets

- Bit Set
- Bloom Filter
- Hash Set
- Multiset
- Ordered Set

### Hashing

- Hash Table
- Hash Functions

### Graphs

- Graph
- Breadth-First Search (BFS)
- Depth-First Search (DFS)
- Shortest Path
- Minimum Spanning Tree
- All Paths

## Puzzles

A lot of software developer interview questions consist of algorithmic puzzles. Here is a small selection of fun ones. For more puzzles (with answers), see [here](http://elementsofprogramminginterviews.com/) and [here](http://www.crackingthecodinginterview.com).

- [Two-Sum Problem](Two-Sum Problem/)

## A note on Big-O notation

It's useful to know how fast an algorithm is and how much space it needs. This allows you to pick the right algorithm for the job.

Big-O notation gives you a rough indication of the running time of an algorithm and the amount of memory it uses. When someone says, "This algorithm has worst-case running time of **O(n^2)** and uses **O(n)** space," they mean it's kinda slow but doesn't need lots of extra memory.

Figuring out the Big-O of an algorithm is usually done through mathematical analysis. We're skipping the math here, but it's useful to know what the different values mean, so here's a handy table. **n** refers to the number of data items that you're processing. For example, when sorting an array of 100 items, **n = 100**.

Big-O | Name | Description
------| ---- | -----------
**O(1)** | constant | This is the best. The algorithm always takes the same amount of time, regardless of how much data there is. Example: looking up an element of an array by its index.
**O(log n)** | logarithmic | Pretty great. These kinds of algorithms halve the amount of data with each iteration. If you have 100 items, it takes about 7 steps to find the answer. With 1,000 items, it takes 10 steps. And 1,000,000 items only take 20 steps. This is super fast even for large amounts of data. Example: binary search.
**O(n)** | linear | Good performance. If you have 100 items, this does 100 units of work. Doubling the number of items to 200 makes the algorithm take twice as long (200 units of work). Example: sequential search.
**O(n log n)** | "linearithmic" | Decent performance. This is slightly worse than linear but not too bad. Example: the fastest sorting algorithms.
**O(n^2)** | quadratic | Kinda slow. If you have 100 items, this does 100^2 = 10,000 units of work. Doubling the number of items makes it four times slower (because 2 squared equals 4). Example: algorithms using nested loops, such as insertion sort.
**O(n^3)** | cubic | Poor performance. If you have 100 items, this does 100^3 = 1,000,000 units of work. Doubling the input size makes it eight times slower. Example: matrix multiplication.
**O(2^n)** | exponential | Very poor performance. You want to avoid these kinds of algorithms, but sometimes you have no choice. Example: traveling salesperson problem.
**O(n!)** | factorial | Intolerably slow. It literally takes a million years to do anything.

Often you don't need math to figure out what the Big-O of an algorithm is but you can simply use your intuition. If your code uses a single loop that looks at all **n** elements of your input, the algorithm is **O(n)**. If the code has two nested loops, it is **O(n^2)**. Three nested loops gives **O(n^3)**, and so on.

Note that Big-O notation is an estimate and is only really useful for large values of **n**. For example, the worst-case running time for the "insertion sort" algorithm is **O(n^2)**. In theory that is worse than the running time for "merge sort", which is **O(n log n)**. But for small amounts of data, insertion sort is actually faster, especially if the array is partially sorted already!

If you find this confusing, don't let this Big-O stuff bother you too much. It's mostly useful when comparing two algorithms to figure out which one is better. But in the end, you still want to test in practice which one really is the best. And if the amount of data is relatively small, then even a slow algorithm will be fast enough for practical use.

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

## License

All content is licensed under the terms of the MIT open source license.
