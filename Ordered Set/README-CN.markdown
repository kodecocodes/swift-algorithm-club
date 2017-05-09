# 有序集合

有序集合是唯一项以排序顺序组合在一起的数据结构。元素通常是由小到大的。

有序集合数据结构是下面数据结构的混合：

- [集合](https://en.wikipedia.org/wiki/Set_%28mathematics%29), 顺序不重要的为一项的组合，和
- [序列](https://en.wikipedia.org/wiki/Sequence), 每个元素可能出现多次的有序列表。

要记住的是两个元素可以有同样的 *value* 但是依然不相等。例如，我们可以定义 “a” 和 “z” 有同样的值（他们的长度，但是显然 "a" != "z"。

## 为什么用有序集合？

当任何时候都需要保持集合是有序时就应该考虑用有序集合，并且查询集合比插入或者删除更频繁。许多对有序集合的查询都是 **O(1)**。

一个好例子就是在计分板上记录玩家的排名（参考下面的例子 2）。

#### 这些是有序集合

整数集合：

	[1, 2, 3, 6, 8, 10, 1000]

字符串集合：

	["a", "is", "set", "this"]

这些字符串的“值”可能是他们自己的文本内容，但是也可以是他们的长度。

#### 这些不是有序集合

这个集合违反了唯一性：

	[1, 1, 2, 3, 5, 8]

这个集合违反了有序性：

	[1, 11, 2, 3]

## 代码

我们以创建有序集合的内部表现来开始。既然集合的概念和数组相似，我们就用数组来表示我们的集合。此外，因为我们要保持集合是有序的，我们需要能够比对单个的元素。因此，任何类型都要遵循 [Comparable Protocol](https://developer.apple.com/library/watchos/documentation/Swift/Reference/Swift_Comparable_Protocol/index.html)。

```swift
public struct OrderedSet<T: Comparable> {
  private var internalSet = [T]()

  // Returns the number of elements in the OrderedSet.
  public var count: Int {
    return internalSet.count
  }
  ...
```

让我们先看看 `insert()` 函数。第一步就是检查元素是否在集合中出现了。如果出现了就直接返回并且不做插入操作。否则的话，就直接通过迭代的方式插入元素。

```swift
  public mutating func insert(_ item: T){
    if exists(item) {
      return  // don't add an item if it already exists
    }

    // Insert new the item just before the one that is larger.
    for i in 0..<count {
      if internalSet[i] > item {
        internalSet.insert(item, at: i)
        return
      }
    }

    // Append to the back if the new item is greater than any other in the set.
    internalSet.append(item)
  }
```

正如稍后我们会看到的，检查元素是否在集合中存在是 **O(log(n) + k)** 的效率，其中 **k** 是我们要插入的元素在集合中的个数。

为了插入新元素，`for` 循环从数组的开始，检查每个元素看是否有比我们要插入的大的。一旦找到这样的元素，我们就插入一个新的到这个地方。这回将数组中剩下的元素变换 1 个位置。循环在最差的时候是 **O(n)**。

所以 `insert()` 函数的整体性能是 **O(n)**。

下一个是 `remove()` 函数：

```swift
  public mutating func remove(_ item: T) {
    if let index = index(of: item) {
      internalSet.remove(at: index)
    }
  }
```

先检查元素是否存在然后再讲它从数组中移除。因为 `removeAtIndex()` 函数，移除的效率是 **O(n)**。

下一个函数是 `indexOf()`，传入一个类型为 `T` 的对象，如果集合中存在的话就返回对应的索引，如果不存在就返回 `nil`。由于我们的集合是有序的，我们可以用二叉搜索来快速搜索元素。

```swift
  public func index(of item: T) -> Int? {
    var leftBound = 0
    var rightBound = count - 1

    while leftBound <= rightBound {
      let mid = leftBound + ((rightBound - leftBound) / 2)

      if internalSet[mid] > item {
        rightBound = mid - 1
      } else if internalSet[mid] < item {
        leftBound = mid + 1
      } else if internalSet[mid] == item {
        return mid
      } else {
      	// see below
      }
    }
    return nil
  }
```

> **注意：** 如果你对二叉搜索的概念不熟悉的话，我们有一篇文章介绍了[二叉搜索](../Binary%20Search)

然而，这里还有一个重要的问题要处理。回忆一下，两个对象可以在用作比较目的的“值”相等时依然是不相等的。因为集合可能包含多个相同值的元素，确保二叉搜索找到了正确的元素是很重要的。

例如，想想 `玩家` 对象的有序集合。每个 `玩家` 都有一个名字和分数：

	[ ("Bill", 50), ("Ada", 50), ("Jony", 50), ("Steve", 200), ("Jean-Louis", 500), ("Woz", 1000) ]

我们想让集合以分数从低到高来排序。多个玩家可能会有相同的分数。对于排序来说，玩家的名字不重要。但是，对于获取正确元素来说名字*是*重要的。

假设我们执行 `indexOf(bill)`，其中 `bill` 是玩家对象 `("Bill", 50)`。如果我们做一个传统的二叉搜索我们得到的是索引 2，其实是对象 `("Jony", 50)`。值 50 匹配了，但是它不是我们要找的对象！

因此，我们还需要检查具有相同值的左边和右边。检查左右两边的代码是这样的：

```swift
        // Check to the right.
        for j in mid.stride(to: count - 1, by: 1) {
          if internalSet[j + 1] == item {
            return j + 1
          } else if internalSet[j] < internalSet[j + 1] {
            break
          }
        }

        // Check to the left.
        for j in mid.stride(to: 0, by: -1) {
          if internalSet[j - 1] == item {
            return j - 1
          } else if internalSet[j] > internalSet[j - 1] {
            break
          }
        }

        return nil
```

这些循环是从 `mid` 值开始然后查找它的邻居值直到我们找到正确的对象。

`indexOf()` 的最后运行时间是 **O(log(n) + k)**，其中 **n** 是集合的长度，**k** 是与要超找的元素具有相同 *值* 的对象在集合中的个数。

既然集合是有序的，下面的操作都是 **O(1)**：

```swift
  // Returns the 'maximum' or 'largest' value in the set.
  public func max() -> T? {
    return count == 0 ? nil : internalSet[count - 1]
  }

  // Returns the 'minimum' or 'smallest' value in the set.
  public func min() -> T? {
    return count == 0 ? nil : internalSet[0]
  }

  // Returns the k-th largest element in the set, if k is in the range
  // [1, count]. Returns nil otherwise.
  public func kLargest(_ k: Int) -> T? {
    return k > count || k <= 0 ? nil : internalSet[count - k]
  }

  // Returns the k-th smallest element in the set, if k is in the range
  // [1, count]. Returns nil otherwise.
  public func kSmallest(_ k: Int) -> T? {
    return k > count || k <= 0 ? nil : internalSet[k - 1]
  }
```

## 例子

下面是一些在 playground 文件中可以找到的例子。

### 例 1

创建一个随机整数的集合。打印集合中最大/最小的 5个数组是非常简单的。

```swift
// Example 1 with type Int
var mySet = OrderedSet<Int>()

// Insert random numbers into the set
for _ in 0..<50 {
  mySet.insert(randomNum(50, max: 500))
}

print(mySet)

print(mySet.max())
print(mySet.min())

// Print the 5 largest values
for k in 1...5 {
  print(mySet.kLargest(k))
}

// Print the 5 lowest values
for k in 1...5 {
  print(mySet.kSmallest(k))
}
```

### 例 2

这个例子中我们就要看看一些更有趣的东西。我们定义一个下面这样的 `Player` 结构：

```swift
public struct Player: Comparable {
  public var name: String
  public var points: Int
}
```

Player 也有自己的 `==` 和 `<` 操作符。`<` 操作符用来决定集合的排序顺序，而 `==` 决定两个对象是否真的相等。
 
注意到 `==` 操作符比较的是名字和分数：

```swifr
func ==(x: Player, y: Player) -> Bool {
  return x.name == y.name && x.points == y.points
}
```

但是 `<` 只比较分数：

```swift
func <(x: Player, y: Player) -> Bool {
  return x.points < y.points
}
```

因此，两个 `Player` 可以偶同样的值（分数），但是不保证他们相等（有不同的名字）。

创建一个新的集合并且插入 20 个随机的玩家。`Player()` 构造器给每个玩家一个随机的名字和分数：

```swift
var playerSet = OrderedSet<Player>()

// Populate the set with random players.
for _ in 0..<20 {
  playerSet.insert(Player())
}
```

插入另一个玩家：

```swift
var anotherPlayer = Player()
playerSet.insert(anotherPlayer)
```

现在我们用 `indexOf()` 函数来找出 `anotherPlayer` 的排名是多少。

```swift
let level = playerSet.count - playerSet.indexOf(anotherPlayer)!
print("\(anotherPlayer.name) is ranked at level \(level) with \(anotherPlayer.points) points")
```

### 例 3

最后的例子说明的是在二叉搜索之后还需要找右边的元素。

插入 9 个玩家到集合中：

```swift
var repeatedSet = OrderedSet<Player>()

repeatedSet.insert(Player(name: "Player 1", points: 100))
repeatedSet.insert(Player(name: "Player 2", points: 100))
repeatedSet.insert(Player(name: "Player 3", points: 100))
repeatedSet.insert(Player(name: "Player 4", points: 100))
repeatedSet.insert(Player(name: "Player 5", points: 100))
repeatedSet.insert(Player(name: "Player 6", points: 50))
repeatedSet.insert(Player(name: "Player 7", points: 200))
repeatedSet.insert(Player(name: "Player 8", points: 250))
repeatedSet.insert(Player(name: "Player 9", points: 25))
```

注意到有许多玩家有同样的 100 分的值。

集合现在是这样的：

	[Player 9, Player 6, Player 1, Player 2, Player 3, Player 4, Player 5, Player 7, Player 8]

下一行就是查找 `Player 2`：

```swift
print(repeatedSet.index(of: Player(name: "Player 2", points: 100)))
```

在二叉搜索结束之后，`mid` 的值是 5：

	[Player 9, Player 6, Player 1, Player 2, Player 3, Player 4, Player 5, Player 7, Player 8]
	                                                      mid

然而，这不是 `Player 2`。`Player 4` 和 `Player 2` 都有同样的分数，但是有不同的名字。二叉搜索只是查找分数，而不找名字。

但是我们知道 `Player 2` 不是在 `Player 4` 的左边就是在右边。我们我们检查 `mid` 的两边。我们只要找和 `Player 4` 有相同值的对象。其他用 `X` 代替：

	[X, X, Player 1, Player 2, Player 3, Player 4, Player 5, X, X]
	                                       mid

代码先检查 `mid` 的右边（ `*` 所在的位置）：

	[X, X, Player 1, Player 2, Player 3, Player 4, Player 5, X, X]
	                                       mid        *

右边没有包含要找的元素，所以我们再找左边：

	[X, X, Player 1, Player 2, Player 3, Player 4, Player 5, X, X]
	                              *        mid        

	[X, X, Player 1, Player 2, Player 3, Player 4, Player 5, X, X]
	                    *                  mid        

最后，我们找到了 `Player 2`，然后返回索引 3。

*作者：Zain Humayun 翻译：Daisy*


