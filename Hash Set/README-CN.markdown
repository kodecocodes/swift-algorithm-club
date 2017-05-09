# 散列集合

集合是像数组一样的元素的汇集，但是又有两个重要饿不同：集合中的元素的顺序是不重要的并且每个元素只能出现一次。

如果下面的是数组，他们就是不一样的。然而，他们都表示相同的集合：

```swift
[1 ,2, 3]
[2, 1, 3]
[3, 2, 1]
[1, 2, 2, 3, 1]
```

因为每个元素只能出现一次，不管你写入几次元素 —— 只会统计一次。

> **注意：** 当我有一组对象但是又不管他们的顺序的时候我更喜欢用集合而不是数组。用集合来与程序员交流就表示元素的顺序不重要。如果用数组的话，就不能假设同样的事情。

对于集合的典型操作是：

- 插入一个元素
- 移除一个元素
- 检查集合是否包含某个元素
- 和另一个集合的并集
- 和另一个集合的交集
- 和另一个集合的差集

交集、并集和差集是将两个结合结合成一个的方法：

![Union, intersection, difference](Images/CombineSets.png)

在 Swift 1.2 中，标准库中包含了内置的 `Set` 类型，但是在这里我要给你展示如何实现自己的集合类型。你不会在生产代码中使用它，但是知道如何实现一个集合是有启发的。

用一个简单的数组来实现一个集合是可能的，但这不是最有效的方式。相反的，我们用字典。因为 `Swift` 的字典是基于散列表来构建的，我们自己的集合会是一个散列集合。

## 代码

下面是 Swift 中 `HashSet` 的开头：

```swift
public struct HashSet<T: Hashable> {
    fileprivate var dictionary = Dictionary<T, Bool>()

    public init() {

    }

    public mutating func insert(_ element: T) {
        dictionary[element] = true
    }

    public mutating func remove(_ element: T) {
        dictionary[element] = nil
    }

    public func contains(_ element: T) -> Bool {
        return dictionary[element] != nil
    }

    public func allElements() -> [T] {
        return Array(dictionary.keys)
    }

    public var count: Int {
        return dictionary.count
    }

    public var isEmpty: Bool {
        return dictionary.isEmpty
    }
}
```

代码非常简单，因为我们依赖的是 Swift 内置的 `Dictionary` 来做所有困难的工作。使用字典的原因是字典的关键字是位移的，就像集合中的元素一样。另外，字典对于它的大部分操作的时间复杂度是 **O(1)**，这就使得集合的实现非常快了。

因为我们用的是字典，泛型类型 `T` 必须遵循 `HashTable`。只要类型可以被散列，就可以假如到集合中（对于 Swift 自己的 `Set` 也是这样的）。

通常来说，用字典是要将关键字和值关联起来，但是对于集合来说，我们只关系关键字。这就是为什么我们用 `Bool` 作为字典的值类型，即使这样我们也只是将它设置成 `true`，而不是 `false`（这里我们选任何东西但是布尔占用最少的空间）。

将代码拷贝到 playground 并且添加一次测试代码：

```swift
var set = HashSet<String>()

set.insert("one")
set.insert("two")
set.insert("three")
set.allElements()      // ["one, "three", "two"]

set.insert("two")
set.allElements()      // still ["one, "three", "two"]

set.contains("one")    // true
set.remove("one")
set.contains("one")    // false
```

`allElements()` 方法将集合的所有内容放到一个数组里。注意到数组中元素的顺序和你添加元素的顺序并不一样。就像我说的，集合不关心元素的顺序（字典也是）。


## 合并集合

集合的很多用途是你如何合并他们（如果你曾经用过向量来画像是草图或者插图，你就会看到像是结合、减法、相交的选项来合并图形 ）。

下面是联合操作的代码：

```swift
extension HashSet {
    public func union(_ otherSet: HashSet<T>) -> HashSet<T> {
        var combined = HashSet<T>()
        for obj in self.dictionary.keys {
            combined.insert(obj)
        }
        for obj in otherSet.dictionary.keys {
            combined.insert(obj)
        }
        return combined
    }
}
```

两个集合的 *并集* 是创建一个新的集合包含集合 A 和 B 的所有元素。当然，如果有重复的元素只会添加一次。

例子：

```swift
var setA = HashSet<Int>()
setA.insert(1)
setA.insert(2)
setA.insert(3)
setA.insert(4)

var setB = HashSet<Int>()
setB.insert(3)
setB.insert(4)
setB.insert(5)
setB.insert(6)

let union = setA.union(setB)
union.allElements()           // [5, 6, 2, 3, 1, 4]
```

就像你看到的，两个集合的并集包含了所有的元素。值 `3` 和 `4` 依然是出现一次，即使他们在两个集合中都有。

两个集合的 *交集* 包含的是两个集合中都有的元素。下面是代码：

```swift
extension HashSet {
    public func intersect(_ otherSet: HashSet<T>) -> HashSet<T> {
        var common = HashSet<T>()
        for obj in dictionary.keys {
            if otherSet.contains(obj) {
                common.insert(obj)
            }
        }
        return common
    }
}
```

测试它：

```swift
let intersection = setA.intersect(setB)
intersection.allElements()
```

会打印 `[3, 4]` 因为他们是仅有的既在集合 A 又在集合 B 中有的对象。

最后，两个集合的 *差集* 移除他们都有的元素。代码是下面这样的：

```swift
extension HashSet {
    public func difference(_ otherSet: HashSet<T>) -> HashSet<T> {
        var diff = HashSet<T>()
        for obj in dictionary.keys {
            if !otherSet.contains(obj) {
                diff.insert(obj)
            }
        }
        return diff
    }
}
```

它实际是 `intersect()` 反面。试试看：

```swift
let difference1 = setA.difference(setB)
difference1.allElements()                // [2, 1]

let difference2 = setB.difference(setA)
difference2.allElements()                // [5, 6]
```

## 要去哪里？

如果你查看 Swift 自己的 `Set` 的[文档](http://swiftdoc.org/v2.1/type/Set/)，你就会注意到它有很多方法。一个显著的扩展是让 `HashSet` 遵循 `SequenceType` 这样就可以用 `for` ... `in` 循环来遍历它。

另外一件可以做的事情是用一个真的[散列表](../Hash%20Table/README-CN.markdown)来替换 `Dictinayr`，但有一件事是只要存储关键字就行，而不需要将它和任何东西关联。所以就不再需要 `Bool` 值了。

如果经常要查看某个元素是否在集合中或者要执行合并操作，那么[联合查找](../Union-Find/README-CN.markdown) 数据结构可能更适合。它用树而不是字典来让查找和联合操作非常高效。

> **注意：** 我喜欢让 `HashSet` 遵循 `ArrayLiteralConvertible`，这样就可以写 `let setA: HashSet<Int> = [1, 2, 3, 4]` 但是现在它会崩溃。

*作者：Matthijs Hollemans 翻译：Daisy*


