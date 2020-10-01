# Binary Indexed (Fenwick) tree

Fenwick Tree is a data structure that can efficiently update elements and calculate prefix sums in a table of numbers.

## Motivation

Let's begin with a small example. Imagine we have an array of numbers:

```
[1, 2, 3, 4, 5, 6]
```

We would like to support:

1. query the sum on some interval

2. update the value of a specified element

There are a lot of ways to implement these operations:

- The most straightforward way is to keep array "as is". Complexity of sum operation would be **O(n)** as we need to calculate sum each time we query it, but the complexity of update will be **O(1)**.

- Next approach comes from dynamic programming. We can precalculate prefix sums inside of some buffer. For the given example precalculated prefix sum is `[1, 3, 6, 10, 15, 21]`. Then we can observe that cumulative sum on interval `(lower-upper)` is `precalculateSum[upper] - precalculateSum[lower] + values[lower]`. Complexity of sum query is **O(1)**, but supporting update operation requires to update all precalculated sums ahead of given index, so, it is **O(n)** for update operation.

- Fenwick tree allows to support these operations in efficient way. Both complexities are **O(ln(n))**.

## Basic

Fenwick Tree supports two basic operations:

1. **update(index, newValue)**: Updates value inside of an array at the given index

2. **query(lowerBound, upperBound)**: Calculates desired cumulative sum on a give range. 


## Basic idea

Binary indexed tree can be represented as an array of size **n + 1**, where **n** is a length of initial array. The data structure is called tree as there is nice representation the data structure as tree.

Basic idea of binary indexed tree is based on a fact that any number can be represented as the sum of powers of 2. For example:

```
7 = 2^2 + 2^1 + 2^0
32 = 2^5
13 = 2^3 + 2^2 + 2^0
```

Each node of the tree stores the sum on the interval from **node_index - 2^b** exclusive to **node_index** inclusive. The **b** stands for the position of last significant bit of the **node_index**. The __0th__ node is a dummy node and keep 0.

```
array <- [ 1, 2, 3, 4, 5, 6] (array indexed starting from 1)

stored range <-  [ 0 - 0 (dummy, no associated array values), 0 - 1, 0 - 2, 2 - 3, 0 - 4, 4 - 5, 4 - 6]

tree <-          [ 0 (dummy), 1, 3, 3, 10, 5, 11]

```

## Sum

To calculate the sum on the interval from **1** up to **val**:

1. While the given index bigger than `0`:

1.1 Find the end of the current interval by extracting last significant byte. To extract last byte you can use the following rule `val - val & (~val + 1)`. This number is the starting point of interval associated with node, when the original one is the end. **3** node keeps the representation of the interval.

1.2 Accumulate the current node value, which is stored inside of a tree. The desired value is tree[index]

1.3 Update the number to the start of it's interval.

1.4 Repeat

For example to calculate the sum from **1** to **3** for the array [**1, 2, 3**, 4, 5, 6] we should do:

0. Tree for thus array looks like [ 0 (dummy), 1, 3, 3, 10, 5, 11].

1. Index is **3**

1.1 `3 = 3 - 3 & (~3 + 1) = 3 - 3 & (0 + 1) = 3 - 3 & 1 = 3 - 1 = 2`, so the interval of the node tree[3] (tree is 0 indexed) is [2-3]

1.2 Sum is 3

1.3 Update the index to **2**

2. Index is **2**

2.1 `2 = 2 - 2 & (~2 + 1) = 2 - 2 & (1 + 1) = 2 - 2 & 2 = 0`. The interval is [0-2], node is tree[2]

2.2  Sum is 3 (from step 1) + 3 (from current step, tree[2])

2.3 Update the index to **0**

3. Index is **0**. Returned sum is **6**.

## Update

Update works like the sum, except it looking for a intervals ahead.

1. While the given index smaller than `n + 1`:

1.1 Find the start of the new interval by extracting last significant byte. To do it you can use the following rule `val + val & (~val + 1)`.

1.2 Accumulate the current node value

1.3 Update the number to the start of following interval.


## See also

See the playground for more examples of how to use this data structure.

[Fenwick Tree at Wikipedia](https://en.wikipedia.org/wiki/Fenwick_tree)

*Written for Swift Algorithm Club by [Alexander Dadukin](https://github.com/st235)