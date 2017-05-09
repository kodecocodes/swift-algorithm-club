# 散列法

散列表可以通过 “key” 来存储和获取对象。

也叫做字典、图、关联数组。还有其他可以实现这些的方法，例如树甚至一个数组，但是散列表是最常见的。

这也就解释了为什么 Swift 内置的 `Dictionary` 类型要求键遵循 `Hashable` 协议：内部使用了散列表，就像你接下来要学到的一样。

## 如何工作

最基本的就是，散列表就是一个数组。开始的时候，数组是空的。当通过某个键插入数据的时候，先用这个键来计算数据在数组中的索引，就像这样：

```swift
hashTable["firstName"] = "Steve"

	The hashTable array:
	+--------------+
	| 0:           |
	+--------------+
	| 1:           |
	+--------------+
	| 2:           |
	+--------------+
	| 3: firstName |---> Steve
	+--------------+
	| 4:           |
	+--------------+
```

在列子中，键 `"firstName"` 和数组的索引 3 对上了。

通过不同的键添加值会将数据放在数组的另一个索引：

```swift
hashTable["hobbies"] = "Programming Swift"

	The hashTable array:
	+--------------+
	| 0:           |
	+--------------+
	| 1: hobbies   |---> Programming Swift
	+--------------+
	| 2:           |
	+--------------+
	| 3: firstName |---> Steve
	+--------------+
	| 4:           |
	+--------------+
```

诀窍就是散列表如何计算数组的索引。这就是散列法开始的地方。当你这样写的时候：

```swift
hashTable["firstName"] = "Steve"
```

散列表接收了 `"firstName"` 这个键的时候，问它要它的 `hashValue` 属性。这就是为什么键需要时 `Hashable` 的原因。

当执行 `"firstName".hashValue` 的时候，它返回一个大的整数：-4799450059917011053。同样的，`"hobbies".hashValue` 也有散列值 4799450060928805186（你看到的值可能不一样）。

当然，这些值要是作为数组索引的话就太大了。有一个还是负数！一个普遍的做法是先将它们变成正数然后再和数组的大小取余数。

数组的大小是 5，所以 `"firstName"` 键的索引就是 `abs(-4799450059917011053) % 5 = 3`。可以自己计算一下 `"hobbies"` 在数组中的索引 是 1。

字典高效的原因就是因为使用散列值：为了从散列表中找到一个元素，通过键的散列值获得数组的索引，然后从数组中查找对应的元素。所有这些操作需要花费的都是固定的时间，所以，插入、获取和三处都是 **O(1)**。

> **注意：** 就像你看到的，很难预测数组是在哪里结束的。这也就是为什么字典不保证数据在散列表中的顺序的原因。

## 避免冲突

有一个问题：由于使我们是用散列值对数组大小取余数，有可能会有两个或者多个键对应着数组的同一个索引。这就叫做冲突。

一个避免冲突的方法就是用一个很大的数组。这回减少两个键同时对应数组的同一个索引的可能性。另一个技巧就是用指数作为数组的大小。然而，冲突还是会发生的，所以需要一个方式来处理冲突。

因为我们的表很小，所以它很容易就产生冲突。例如，键 `"lastName"` 的索引也是 3。这就是一个问题了，因为我们不想讲原来数组中的值覆盖掉。

有很多方法可以用来处理冲突。普遍做法是用链。数组现在是这样的：

```swift
	buckets:
	+-----+
	|  0  |
	+-----+     +----------------------------+
	|  1  |---> | hobbies: Programming Swift |
	+-----+     +----------------------------+
	|  2  |
	+-----+     +------------------+     +----------------+
	|  3  |---> | firstName: Steve |---> | lastName: Jobs |
	+-----+     +------------------+     +----------------+
	|  4  |
	+-----+
```

有了链，键和它们的值不是直接存在数组里。相反的，每个数组元素都是一个具有另个或者多个键/值对的列表。数组元素通常叫做 *桶*，列表就叫做 *链*。所以我们就有 5 个桶，其中两个桶里有链。其他的三个桶是空的。

如果我们现在通过下面的方式从散列表中获取一个元素：

```swift
let x = hashTable["lastName"]
```

先对键 `"lastName"` 取散列值来获得数组的索引，也就是 3。桶 3 有一个链，然后编列列表来找到键为 `"lastName"` 的值。这是通过比较键来实现的，所以这就引入了一个字符串比较。散列表发现它在链的最后一个，所以返回它对应的值，`"Jobs"`。

实现这个链机制的普遍方法是使用链表或者另一个数组。技术上来说，链中的元素的顺序不重要，所以也可以将它认为是一个集合而不是列表（现在你也可以想一下术语 “桶* 是从哪里来的了；我们只是将所有的对象都扔到桶里）。

不要使得链变得太长，否则从散列表里查找一个元素就会变得很慢了。理论上来说，我们不希望有链存在，但实际中很难避免冲突。可以通过给散列表更多的桶或者使用一个高质量的散列函数来避免冲突。

> **注意：** 链的另外一个可选方式是 ”开放地址“。想法是这样的：如果数组的索引已经被占用了，那么将它放在下一个未使用的桶里。当然，这个方法也有它自己的优点和缺点。

## 代码

来看看 Swift 中一个基本的散列表的实现吧。我们会一步步来。

```swift
public struct HashTable<Key: Hashable, Value> {
  private typealias Element = (key: Key, value: Value)
  private typealias Bucket = [Element]
  private var buckets: [Bucket]

  private(set) public var count = 0
  
  public var isEmpty: Bool { return count == 0 }

  public init(capacity: Int) {
    assert(capacity > 0)
    buckets = Array<Bucket>(repeatElement([], count: capacity))
  }
```

HashTable 是一个反省容器，两个泛型类型分别叫做 `Key`（必须是 `Hashable` 的） 和 `Value`。我们还定义了另外两个类型：Element 是在链中用的 键/值 对，`Bucket` 是一个 `Elements` 的数组。

主数组叫做 `buckets`。它有一个固定的大小，就是所谓的容量，是由 `init(capacity)` 方法提供的。同时我们也用 `count` 变量来记录散列表中已经添加了多少个元素。

创新新的散列表对象的列子：

```swift
var hashTable = HashTable<String, String>(capacity: 5)
```

现在散列表还没有任何数据，让我们来添加其他的功能吧。首先，添加一个辅助方法用来计算给定键的数组索引：

```swift
  private func index(forKey key: Key) -> Int {
    return abs(key.hashValue) % buckets.count
  }
```

这里执行的就是我们之前看到的计算：取键的 `hashValue` 的绝对值然后对桶数组的大小求余数。把这个辅助方法作为散列表的内部方法，后面还有好多地方要用到它。

对于一个散列表或者字典来说，还有四个典型的操作：

- 插入一个新的元素
- 查找元素
- 更新已存在的元素
- 删除元素

语法就是像下面这样的：

```swift
hashTable["firstName"] = "Steve"   // insert
let x = hashTable["firstName"]     // lookup
hashTable["firstName"] = "Tim"     // update
hashTable["firstName"] = nil       // delete
```

所有这些都可以通过 `subscript` 函数来完成：

```swift
  public subscript(key: Key) -> Value? {
    get {
      return value(forKey: key)
    }
    set {
      if let value = newValue {
        updateValue(value, forKey: key)
      } else {
        removeValue(forKey: key)
      }
    }
  }
```

调用了三个辅助方法来完成实际的工作。我们先来看看 `value(forKey:)`，从散列表中获取一个对象。

```swift
  public func value(forKey key: Key) -> Value? {
    let index = self.index(forKey: key)
    for element in buckets[index] {
      if element.key == key {
        return element.value
      }
    }
    return nil  // key not in hash table
  }
```

首先它调用 `index(forKey:)` 来将键转成数组索引。给出来的是桶的数字，但是如果这个桶有冲突的话，它就有可能被多个键使用。所以 `value(forKey:)` 从桶中遍历链然后一个个对比键。如果找到了，就返回对应的值，如果没有就返回 `nil`。

添加新元素和更新新元素的代码都在 `updateValue(_:forKey:)`。它稍微有点复杂：

```swift
  public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
    let index = self.index(forKey: key)
    
    // Do we already have this key in the bucket?
    for (i, element) in buckets[index].enumerate() {
      if element.key == key {
        let oldValue = element.value
        buckets[index][i].value = value
        return oldValue
      }
    }
    
    // This key isn't in the bucket yet; add it to the chain.
    buckets[index].append((key: key, value: value))
    count += 1
    return nil
  }
```

第一件要做的事情就是将键转成数组索引来找到桶。然后遍历这个桶的链。如果找到了对应的键，就意味着我们要用新的值替换旧的。如果键不在链中，插入新的 键/值 对到链的最后。

正如你所看到的，保持链的长度比较短是很重要的（通过把散列表弄得足够大）。否则，会花费很多时间在  `for`...`in` 循环里，散列表的性能就不再是 **O(1)**，而是 **O(n)**了。

删除操作跟前面的也差不多，也是要遍历整个链：

```swift
  public mutating func removeValue(forKey key: Key) -> Value? {
    let index = self.index(forKey: key)

    // Find the element in the bucket's chain and remove it.
    for (i, element) in buckets[index].enumerated() {
      if element.key == key {
        buckets[index].remove(at: i)
        count -= 1
        return element.value
      }
    }
    return nil  // key not in hash table
  }
```

这些是散列表的基本函数。它们的工作方式都是一样的：用键的散列值来计算数组的索引，找到桶，然后遍历桶里的链然后执行想要的操作。

在 playground 里试试这些吧。它就是标准的 Swift 的 `Dictionary` 一样。

## 调整散列表的大小

这个版本的 `HashTable` 使用的是固定大小或容量的数组。如果你直到要存储多少数据的时候这很好。对于容量来说，选择一个比你希望要存储的最大数量的元素的质数。

*负载因子* 是当前已经被使用的容量的百分比。如果有 5 个桶的散列表中有三个元素，那么负载因子就是 `3/5 = 60%`。

如果散列表太小，链太长的话，负载因子可能大于 1。这并不是很好。

如果负载因子变的太大，比如 > 75%，我们可以调整散列表的大小。将添加这个功能的代码留给读者自己实现。要记住的是改变桶数组的大小也会改变键对应的数组索引，为了考虑这个，要在改变数组大小之后重新将元素添加到新数组中。

## 下一步是哪里？

`HashTable` 是非常基础的。例如，将它和 Swift 的标准库结合起来做一个 `SequenceType` 会很有趣。

*作者：Matthijs Hollemans 翻译：Daisy*


