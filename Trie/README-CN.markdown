# Trie

## 什么是 Trie？

`Trie`，（也叫做前缀树，或者在其他一些实现中也叫基树）是一种用来存储关联数据结构的特殊类型的树。字典的 `Trie` 可能看起来是这样的：

![A Trie](images/trie.png)

存储英语语言是 `Trie` 的一个主要用途。`Trie` 中的每个节点表示的是词的一个字符。一系列节点组成了一个词。

## 为什么是 Trie ？

在某些情况下 Tires 是非常有用的。下面是一些优点：

* 在最差情况下查找值通常来说有一个更好的时间复杂度。
* 与堆图不一样的是，`Trie` 不需要担心关键字冲突。
* 不使用散列来保证元素的唯一路径
* `Trie` 结构默认就是按字符顺序存储的

## 通用算法

### 包含 (或其他一般查找方法)

`Trie` 结构对于查找操作来说是非常好的。对于模拟英语语言的 `Trie` 结构来说，找到一个词只是一些指针遍历的事情：

```swift
func contains(word: String) -> Bool {
	guard !word.isEmpty else { return false }

	// 1
	var currentNode = root
  
	// 2
	var characters = Array(word.lowercased().characters)
	var currentIndex = 0
 
	// 3
	while currentIndex < characters.count, 
	  let child = currentNode.children[characters[currentIndex]] {

	  currentNode = child
	  currentIndex += 1
	}

	// 4
	if currentIndex == characters.count && currentNode.isTerminating {
	  return true
	} else {
		return false
	}
}
```

`contains` 方法是非常直接的：

1. 创建一个指向 `root` 的引用。这个应用是用来遍历一系列节点的。
2. 跟踪你要匹配的词的字符
3. 指针沿着节点往下移动
4. `isTerminating` 是一个布尔标志用来标志节点是否是词的最后。如果满足了 `if` 条件，就意味你可以在 `Trie` 中找到这个词。

### 插入

往 `Trie` 里插入要求遍历节点直到要么停在某个被标记为 `terminating` 的节点，要么到了要插入额外节点的地方。

```swift
func insert(word: String) {
  guard !word.isEmpty else {
    return
  }

  // 1
  var currentNode = root

  // 2
  for character in word.lowercased().characters {
    // 3
    if let childNode = currentNode.children[character] {
      currentNode = childNode
    } else {
      currentNode.add(value: character)
      currentNode = currentNode.children[character]!
    }
  }
  // Word already present?
  guard !currentNode.isTerminating else {
    return
  }

  // 4
  wordCount += 1
  currentNode.isTerminating = true
}
```

1. 再一次，创建一个指向根节点的引用。沿着一系列节点往下移动这个引用。
2. 一个字母一个字母的遍历词
3. 有时，需要插入的节点已经存在了。这就是 Trie 中的两个词共享了一些字母（例如，“Apple”，“App”）的情况。如果字符已经存在的话，你可以重用它，并且简单的沿着链继续往下。否则的话，就创建一个新的节点来表示这个字母。
4. 一旦到了最后，将 `isTerminating` 标记为 true 来将特定的节点标记为词的结束。

### 删除

从 `Trie` 里删除关键字就有点棘手了，因为需要考虑到很多种情况。`Trie` 中的节点可能是被不同的词共享的。看看 “Apple” 和 “App” 这两个词就知道了。在 `Trie` 中，表示 “App” 的节点链是和 “Apple” 共享的。

如果你想要移除 “Apple”，要掌握好保留 “App” 链的分寸。

```swift
func remove(word: String) {
  guard !word.isEmpty else {
    return
  }

  // 1
  guard let terminalNode = findTerminalNodeOf(word: word) else {
    return
  }

  // 2
  if terminalNode.isLeaf {
    deleteNodesForWordEndingWith(terminalNode: terminalNode)
  } else {
    terminalNode.isTerminating = false
  }
  wordCount -= 1
}
```

1. `findTerminalNodeOf` 遍历 Trie 找到表示这个 `word` 的最后一个节点。如果不能遍历整个字符链，就返回 `nil`。
2. `deleteNodesForWordEndingWith` 往后遍历，删除表示 `word` 里有的节点
5. 

### 时间复杂度

假设 n 是 `Trie` 中某个值的长度。

* `contains` - 最差 O(n)
* `insert` - O(n)
* `remove` - O(n)

### 其他值得注意的操作

* `count`：返回 `Trie` 中的关键词的个数 - O(1)
* `words`：返回 `Trie` 中所有关键词的列表 - O(1)
* `isEmpty`：如果 `Trie` 是空的返回 `true`，否则返回 `false` - O(1)

参考 [Wikipedia entry for Trie](https://en.wikipedia.org/wiki/Trie).

*作者Christian Encarnacion 修正：Kelvin Lau 翻译：Daisy*

# Rick Zaccone 的修改

* 给所有方法添加注释
* 重构 `remove` 方法
* 重命名一些变量。对于 Swift 的推断类型我有不同的感受。一个变量有什么类型并不总是很明显的。为了解决这个问题，我将 `parent` 重命名为 `parentNode` 来强调它是一个节点而不是节点中的值。
* 添加 `words` 属性用来遍历 trie 和构造 trie 中包含的所有的词的数组。
* 添加 `isLeaf` 属性给 `TrieNode` 增加可读性。
* 实现 trie 的 `count` 和 `isEmpty` 属性
* 我尝试通过添加 162,825 个词来堆 trie 进行压力测试。当添加这些词的时候，playground 非常慢并且最终崩溃了。为了解决这个问题，我把所有东西都放到一个工程里，然后写了 `XCTest` 测试来测试 trie。还有一些性能测试。所有的都通过了测试。


