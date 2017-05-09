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

[什么是算法和数据结构?](What%20are%20Algorithms-CN.markdown) 薄煎饼!

[为什么学习算法？](Why%20Algorithms-CN.markdown) 还在担心这不是你的菜吗？看看这个吧

[大 O 表示法](Big-O%20Notation-CN.markdown)。 我们经常会说“这个算法是**O(n)**”。如果你不知道这是什么意思，读读这篇吧。

[算法设计技巧](Algorithm%20Design-CN.markdown)。怎样设计自己的算法？

[如何做贡献](How%20to%20Contribute-CN.markdown)。报告问题或者提交 pull 请求

[构建中](Under%20Construction-CN.markdown)。 还没有实现的算法

## 从哪里开始

如果你是一个新手，下面的文章是一个很好的开始：

- [栈](Stack/README-CN.markdown)
- [队列](Queue/README-CN.markdown)
- [插入排序](Insertion%20Sort/README-CN.markdown)
- [二分搜索](Binary%20Search/README-CN.markdown) 和 [二叉搜索树](Binary%20Search%20Tree/README-CN.markdown)
- [归并排序](Merge%20Sort/README-CN.markdown)
- [Boyer-Moore 字符串搜索](Boyer-Moore/README-CN.markdown)

## 算法

### 搜索

- [线性搜索](Linear%20Search/README-CN.markdown)。 在数组中查找一个元素
- [二分搜索](Binary%20Search/README-CN.markdown)。 在有序数组中快速查找元素。
- [计算出现频率](Count%20Occurrences/README-CN.markdown)。统计值在数组中出现的频率
- [查找最大/最小值](Select%20Minimum%20Maximum/README-CN.markdown)。 查找数组中的最大最小值
- [第 k 大的元素](Kth%20Largest%20Element/README-CN.markdown)。找到数组中第 *k* 大的元素，比如中间值。
- [选取样本](Selection%20Sampling/README-CN.markdown)。 从集合中随机选择一些样本
- [联合查找](Union-Find/README-CN.markdown)。 跟踪不相交的集合并且快速合并它们

### 字符串搜索

- [暴力字符串搜索](Brute-Force%20String%20Search/README-CN.markdown). 一个简单的方法
- [Boyer-Moore](Boyer-Moore/README-CN.markdown)。一个快速搜索子字符串的方法。它基于一个查询表来跳过一些字符来避免查找文本中的每个字符。
- [Knuth-Morris-Pratt](Knuth-Morris-Pratt/README-CN.markdown)
- [Rabin-Karp](Rabin-Karp/README-CN.markdown)  使用散列的快速搜索。
- [最长公共子序列](Longest%20Common%20Subsequence/README-CN.markdown). 找到两个字符串中相同顺序的最长公共子序列。
- [Z 算法](Z-Algorithm/README-CN.markdown). 找到字符串里所有的模式实例，并且返回模式在字符串中开始的位置的索引。 

### 排序

看排序算法是如何工作的是很有意思的，但在实际中却几乎不可能用自己的排序程序。Swift 自己的 `sort()` 已经可以满足工作了，但是如果你好奇的话，请继续阅读吧...

基本排序:

- [插入排序](Insertion%20Sort/README-CN.markdown) 
- [选择排序](Selection%20Sort/README-CN.markdown) 
- [希尔排序](Shell%20Sort/README-CN.markdown) 

快速排序:

- [快速排序](Quicksort/README-CN.markdown) 
- [归并排序](Merge%20Sort/README-CN.markdown) 
- [堆排序](Heap%20Sort/README-CN.markdown) 

特殊目的的排序:

- [计数排序](Counting%20Sort/README-CN.markdown)
- [基数排序](Radix%20Sort/README-CN.markdown)
- [拓扑排序](Topological%20Sort/README-CN.markdown)

糟糕的排序算法 (不要用它们!):

- [冒泡排序](Bubble%20Sort/README-CN.markdown)
- [慢排序](Slow%20Sort/README-CN.markdown)

### 压缩

- [游程编码 (RLE)](Run-Length%20Encoding/README-CN.markdown). 将重复的字节存储为一个值和一个数量。
- [哈夫曼编码](Huffman%20Coding/README-CN.markdown). 用更少的位保存更常出现的元素。

### 杂七杂八

- [洗牌](Shuffle/README-CN.markdown). 随机重新排列数组的内容。
- [梳排序](Comb%20Sort/README-CN.markdown). 冒泡排序算法的改进。

### 数学

- [最大公约数 (GCD)](GCD/README-CN.markdown). 特别姜力：最小公倍数
- [排列和组合](Combinatorics/README-CN.markdown). 捡起你的组合吧！
- [调度场算法](Shunting%20Yard/README-CN.markdown). 将中缀表达式转换成后缀表达式。
- Statistics
- [Karatsuba 乘法](Karatsuba%20Multiplication/README-CN.markdown). 基本乘法的另一个方式。
- [Haversine 距离](HaversineDistance/README-CN.markdown). 计算球面上两点之间的距离。

### 机器学习

- [k-Means 聚类](K-Means/README-CN.markdown). 将数据分成 *k* 个簇的无监督分类
- k-Nearest Neighbors
- [线性回归](Linear%20Regression/README-CN.markdown)
- Logistic Regression
- Neural Networks
- PageRank

## 数据结构

对于特定任务的数据结构的选择取决于一些情况。

首先，要有一个数据的形式以及要对数据执行的操作。如果你要通过关键词来查找对象的话，那么你就需要类似字典的东西；如果你的数据本身是有层级的，那么就要用类似树的结构了；如果数据是连续的，栈或者队列都是一个可选项。

其次，经常执行哪些特定的操作很重要，因为一些数据结构会针对特定行为做优化。例如，如果想在集合中找到最重要的对象，那么一个堆或者优先列表就比数组要好的多。

大部分情况下内置的 `Array`、`Dictionary` 和 `Set` 就够用了，但有时可能想要一些更好的。

### 数组的变种

- [二维数组](Array2D/README-CN.markdown). 固定大小的二维数组。在棋盘游戏中非常有用。
- [位集](Bit%20Set/README-CN.markdown). 固定大小的 *n* 位系列。
- [固定大小的数组](Fixed%20Size%20Array/README-CN.markdown). 但提前知道有多少数据的时候，用一个固定大小的老式数组可能更高效。
- [有序数组](Ordered%20Array/README-CN.markdown). 有序数组.
- [Rootish 数组栈](Rootish%20Array%20Stack/README-CN.markdown). Swift 数组的一个空间和时间高效的变种

### 队列

- [栈](Stack/README-CN.markdown)。 后进先出！
- [队列](Queue/README-CN.markdown)。 先进先出！
- [双端队列](Deque/README-CN.markdown). 双端队列.
- [优先队列](Priority%20Queue/README-CN.markdown). 最重要的的元素始终在开始的队列。
- [环形缓冲区](Ring%20Buffer/README-CN.markdown). 也叫做圆形缓冲区。从概念上来说是绕回到开始的一定大小的数组。

### 链表

- [链表](Linked%20List/README-CN.markdown). 通过链接连接数据元素的系列。包括单项链表和双向链表。
- [跳跃表](Skip-List/README-CN.md). 跳跃表是一种概率数据结构，与 AVL 或者红黑树有着同样的时间效率，对搜索和更新操作提供了一个聪明的妥协。

### 树

- [树](Tree/README-CN.markdown). 一般用途的树结构
- [二叉树](Binary%20Tree/README-CN.markdown). 每个节点最多有两个子节点的数。
- [二叉搜索树 (BST)](Binary%20Search%20Tree/README-CN.markdown). 二叉树以能快速查询的方式来安排它的节点。
- [红黑树](Red-Black%20Tree/README-CN.markdown)
- Splay Tree
- [线索二叉树](Threaded%20Binary%20Tree/README-CN.markdown)
- [线段树](Segment%20Tree/README-CN.markdown). 可以在数组的一部分上快速执行操作。
- kd-Tree
- [堆](Heap/README-CN.markdown). 数组中的有序二叉树，所以它不使用指针。它是一个非常好的优先队列。
- Fibonacci Heap
- [Trie](Trie/README-CN.markdown). 用来存储关联类型数据结构的特殊类型的树。
- [B 树](B-Tree/README-CN.markdown). 一个自平衡搜索树，它的节点可以有多于两个子节点。

### 散列法

- [散列表](Hash%20Table/README-CN.markdown). 可以通过关键词存储和获取对象。字典通常就是这样实现的。
- Hash Functions

### 集合

- [布隆过滤器](Bloom%20Filter/README-CN.markdown). 一种固定内存大小的数据结构，可以大概地测试元素是否在集合中。
- [散列集合](Hash%20Set/README-CN.markdown). 用散列表实现的集合。
- Multiset
- [有序集合](Ordered%20Set/README-CN.markdown). 关心元素顺序的集合。

### 图

- [图](Graph/README-CN.markdown)
- [广度优先搜索 (BFS)](Breadth-First%20Search/README-CN.markdown)
- [深度优先搜索 (DFS)](Depth-First%20Search/README-CN.markdown)
- [最短路径](Shortest%20Path%20%28Unweighted%29/README-CN.markdown) 无权图
- [单源最短路径](Single-Source%20Shortest%20Paths%20(Weighted)/README-CN.markdown)
- [最小生成树](Minimum%20Spanning%20Tree%20%28Unweighted%29/README-CN.markdown) 无权图
- [全源最短路径](All-Pairs%20Shortest%20Paths/README-CN.markdown)

## 谜题

许多软件开发者的面试都会涉及到算法题。这里是一些比较有意思的。可以从[这里](http://elementsofprogramminginterviews.com/)和[这里](http://www.crackingthecodinginterview.com)查看更多的题（都有答案）。

- [两和问题](Two-Sum%20Problem/README-CN.markdown)
- [Fizz Buzz](Fizz%20Buzz/README-CN.markdown)
- [蒙提霍尔问题](Monty%20Hall%20Problem/README-CN.markdown)
- [查找回文](Palindromes/README-CN.markdown)
- [哲学家就餐问题](DiningPhilosophers/README-CN.markdown)

## 持续学习！

查看下面这些好书可以获得更多的信息：

- [Introduction to Algorithms](https://mitpress.mit.edu/books/introduction-algorithms) by Cormen, Leiserson, Rivest, Stein
- [The Algorithm Design Manual](http://www.algorist.com) by Skiena
- [Elements of Programming Interviews](http://elementsofprogramminginterviews.com) by Aziz, Lee, Prakash
- [Algorithms](http://www.cs.princeton.edu/~rs/) by Sedgewick
- [Grokking Algorithms](https://www.manning.com/books/grokking-algorithms) by Aditya Bhargava 

下面这些书可以在线免费获得：

- [Algorithms](http://www.beust.com/algorithms.pdf) by Dasgupta, Papadimitriou, Vazirani
- [Algorithms, Etc.](http://jeffe.cs.illinois.edu/teaching/algorithms/) by Erickson
- [Algorithms + Data Structures = Programs](http://www.ethoberon.ethz.ch/WirthPubl/AD.pdf) by Wirth
- Algorithms and Data Structures: The Basic Toolbox by Mehlhorn and Sanders
- [Open Data Structures](http://opendatastructures.org) by Pat Morin
- [Wikibooks: Algorithms and Implementations](https://en.wikibooks.org/wiki/Algorithm_Implementation)

其他算法仓库：

- [EKAlgorithms](https://github.com/EvgenyKarkan/EKAlgorithms). Objective-C 算法大集合。
- [@lorentey](https://github.com/lorentey/). 产品级的通用算法和数据结构的 Swift 实现。
- [Rosetta Code](http://rosettacode.org). 你能想到的所有语言的实现。
- [AlgorithmVisualizer](http://jasonpark.me/AlgorithmVisualizer/). 浏览器可视化算法实现。
- [Swift Structures](https://github.com/waynewbishop/SwiftStructures) 如何使用数据结构和算法 [这里](http://waynewbishop.com/swift)

## 贡献者

Swift 算法俱乐部最开始是由  [Matthijs Hollemans](https://github.com/hollance) 创建的。

现在由 [Vincent Ngo](https://www.raywenderlich.com/u/jomoka) 和 [Kelvin Lau](https://github.com/kelvinlauKL) 维护。

Swift 算法俱乐部是 [raywenderlich.com](https://www.raywenderlich.com) 社区 [most algorithmic members](https://github.com/rwenderlich/swift-algorithm-club/graphs/contributors) 努力的结果。我们一直都在寻求帮助 - 为什么不 [加入俱乐部](How%20to%20Contribute-CN.markdown)? :]

## 许可证

所有内容都是基于 MIT 的开源许可证。

要通过这个论坛在这里发布、提交或者拉请求，就要同意所有你提交或者创建的内容，包括代码和文本，都要遵循这个许可证。Razeware, LLC 和其他所有者有内容的最终解释权。许可证的准确内容在[这里](https://github.com/raywenderlich/swift-algorithm-club/blob/master/LICENSE.txt)。

[![Build Status](https://travis-ci.org/raywenderlich/swift-algorithm-club.svg?branch=master)](https://travis-ci.org/raywenderlich/swift-algorithm-club)


