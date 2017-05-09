# 链表

链表是数据项系列，就像是一个数组。但是数组是分配一大块内存用来存储对象，链表里的元素在内存中是完全分离的，他们是通过链接连接在一起的：

	+--------+    +--------+    +--------+    +--------+
	|        |    |        |    |        |    |        |
	| node 0 |--->| node 1 |--->| node 2 |--->| node 3 |
	|        |    |        |    |        |    |        |
	+--------+    +--------+    +--------+    +--------+

链表中的元素叫做 *节点*。上面的图展示了一个 *简单链表*，每个节点都由一个引用 —— 或者说是 “指针” —— 指向下一个节点。在 *双向链表*中，如下面所示，节点里还有一个指向前一个节点的指针：

	+--------+    +--------+    +--------+    +--------+
	|        |--->|        |--->|        |--->|        |
	| node 0 |    | node 1 |    | node 2 |    | node 3 |
	|        |<---|        |<---|        |<---|        |
	+--------+    +--------+    +--------+    +--------+

要记录链表是从哪里开始的。通常是用一个叫做 *head* 的指针来表示：

	         +--------+    +--------+    +--------+    +--------+
	head --->|        |--->|        |--->|        |--->|        |---> nil
	         | node 0 |    | node 1 |    | node 2 |    | node 3 |
	 nil <---|        |<---|        |<---|        |<---|        |<--- tail
	         +--------+    +--------+    +--------+    +--------+

有一个指向链表结尾的引用也是非常有用的，叫做 *tail*。最后一个节点的 “next” 指针指向的是 `nil`，就像第一个节点的 “previous” 指针一样。

## 链表的性能

大部分针对链表的操作都是 **O(n)**，所以一般来说链表比数组要慢。但是，他们更灵活 —— 不像数组一样需要拷贝大块内存，大部分链表的操作指示要改变一些指针。

**O(n)** 时间的原因是不能简单地写一个 `list[2]` 来方位列表中的节点 2。如果没有一个指向这个节点的指针，就必须要从 `head` 开始，通过 `next` 指针来往下找到那个节点（或者从 `tail` 开始通过 `previous` 指针来往前找）。

一旦有了某个节点的引用，对这个节点的插入和删除操作都会很快。指示找到节点有点慢。

这就意味着当处理链表时，无论如何都应该在开头插入节点。这是 **O(1)** 的操作。同样的，如果有 `tail` 指针的话，在最后插入也是 **O(1)** 的操作。

## 单项 vs 双向链表

单向链表比双向链表用的内存更少，因为单向链表不需要存储 `previous` 指针。

但如果有一个节点，想要找到它的前一个节点的时候，你就完蛋了。必须从头开始然后遍历整个列表直到找到正确的节点。

对于很多任务来说，双向链表让事情变得更简单。

## 为什么使用链表？

一个典型的使用链表的场景是当你需要一个 [队列](../Queue/README-CN.markdown) 的时候。用数组的话，从数组的开头移除一个元素会比较慢，因为它需要将剩下的元素在内存中挪动位置。但是用链表的话，只要把 `head` 指针挪到第二个元素就可以了，这就快多了。

但是老实说，今天你完全不需要自己写一个链表。但是理解他们是如何工作的还是有用的；将对象连接起来的规则也适用于 [树](../Tree/README-CN.markdown) 和 [图](../Graph/README-CN.markdown)。

## 代码

让我们从定义一个描述节点的类型开始吧：

```swift
public class LinkedListNode<T> {
  var value: T
  var next: LinkedListNode?
  weak var previous: LinkedListNode?

  public init(value: T) {
    self.value = value
  }
}
```

这是一个泛型类型，所以 T 可以是任何你想要存储的数据类型。下面我们会用字符串。

我们的是一个双向链表，每个节点有一个 `next` 和 `previous` 指针。如果没有下一个或者前一个节点的话，它们可以是 `nil`，所以这些变量是可选的。（下面我会指出如果是单项链表而不是双向链表的话，哪些地方是需要变化的，）

> **注意：** 为了避免循环引用，将 `previous` 定义为 `weak` 的。如果有一个 `B` 节点跟在 `A` 节点后面，那么 `A` 指向 `B` 并且 `B` 也指向 `A`。在某些情况下，这个循环引用会导致在删除了节点之后他们依然会存在在内存中。我们不想要这样，所以利用 `weak` 指针来打破这个循环。

现在开始构建 `LinkedList` 把。下面是第一点：

```swift
public class LinkedList<T> {
  public typealias Node = LinkedListNode<T>

  private var head: Node?
  
  public var isEmpty: Bool {
    return head == nil
  }
  
  public var first: Node? {
    return head
  }
}
```

理想情况下，我想把 `LinkedListNode` 类放到 `LinkedList` 里面，但是 Swift 现在不允许在泛型类型里有内嵌类型。所以我们就用 typealias，所以在 `LinkedList` 里面，可以用简单的 `Node` 来代替 `LinkedListNode<T>`。

这个链表只有一个 `head` 指针，没有 `tail`。添加 `tail` 指针就留着读者作为作业了。（我会指出来如果有 `tail` 指针的话哪里会不一样。）


如果 `head` 是 `nil` 的话，那么链表就是空的。因为 `head` 是私有变量，所以我又 加了一个叫 `first` 的属性来返回列表中的第一个节点。

可以在 playground 中试试这个：

```swift
let list = LinkedList<String>()
list.isEmpty   // true
list.first     // nil
```

我们再添加一个属性来返回列表的最后一个节点。这就是它开始有趣的地方：

```swift
  public var last: Node? {
    if var node = head {
      while case let next? = node.next {
        node = next
      }
      return node
    } else {
      return nil
    }
  }
```

如果你是一个 Swift 新手，你可能已经见过 `if let` 但是还没有见过 `if var`。它做的事情是一样的 —— 拆取 `head` 的值并且将结果当道新的本地变量 `node` 里。不同之处在于 node 不是常量而是一个变量，这样我们就可以在循环里改变它了。

循环里也做了一些 Swift 的魔法。`while case let next? = node.next` 一直循环直到 `node.next` 为 `nil`。你曾经可能是这样写的：

```swift
      var node: Node? = head
      while node != nil && node!.next != nil {
        node = node!.next
      }
```

但是这对于我来说就非常不 Swifty 了。我们应该利用 Swift 的对于拆取可选的内置支持。在接下来的代码中你会看到一堆这样的循环。

> **注意：** 如果我们保留一个 `tail` 指针， `last` 就是简单的 `return tail`。但是，我们没有，所以就必须从开始遍历到列表的最后。这是一个耗时的操作，尤其是当链表很长的时候。

当然，如果列表中没有节点的话 `last` 就返回 `nil`。我们来添加一个方法来在链表的最后添加节点：

```swift
  public func append(value: T) {
    let newNode = Node(value: value)
    if let lastNode = last {
      newNode.previous = lastNode
      lastNode.next = newNode
    } else {
      head = newNode
    }
  }
```

`append()` 方法先创建一个新的 `Node` 对象，然后用我们刚添加的 `last` 属性得到最后的节点。如果没有节点的话，链表还是空的，我们就将 `head` 指向现在这个新的 `Node`。但是如果我们找到了一个有效的节点西乡，我们就将 `next` 和 `previous` 连起来将新的节点连接到列表里。好多链表的代码都涉及到这种 `next` 和 `previous` 指针的操作。

在 playground 中测试一下：

```swift
list.append("Hello")
list.isEmpty         // false
list.first!.value    // "Hello"
list.last!.value     // "Hello"
```

链表看起来是这样的：

	         +---------+
	head --->|         |---> nil
	         | "Hello" |
	 nil <---|         |
	         +---------+

现在添加第二个节点：

```swift
list.append("World")
list.first!.value    // "Hello"
list.last!.value     // "World"
```

链表看起来是这样的：

	         +---------+    +---------+
	head --->|         |--->|         |---> nil
	         | "Hello" |    | "World" |
	 nil <---|         |<---|         |
	         +---------+    +---------+

你可以自己通过查看 `next` 和 `previous` 指针来验证：

```swift
list.first!.previous          // nil
list.first!.next!.value       // "World"
list.last!.previous!.value    // "Hello"
list.last!.next               // nil
```

我们再添加一个方法来看看链表中有多少节点。这看起来很像我们已经做过的：

```swift
  public var count: Int {
    if var node = head {
      var c = 1
      while case let next? = node.next {
        node = next
        c += 1
      }
      return c
    } else {
      return 0
    }
  }
```

它用同样的方式遍历整个列表，但是这次同时还增加了一个计数器。

> **注意：** 一个让 `count` 从 **O(n)** 加速到到 **O(1)** 的方法是用一个变量来保存链表中节点的数量。不管你添加还是删除节点的时候，同时更新这个变量即可。

假如我们想要找到列表中特定索引的节点该怎么办呢？数组的话只要用 `array[index]` 就可以了，它是 **O(1)** 的操作。链表的话就有点不够了，但下面的代码还是有一些相似的模式的：

```swift
  public func nodeAt(_ index: Int) -> Node? {
    if index >= 0 {
      var node = head
      var i = index
      while node != nil {
        if i == 0 { return node }
        i -= 1
        node = node!.next
      }
    }
    return nil
  }
```

循环看起来有些不一样，但它做的是同一件事：从 `head` 开始，然后跟着 `node.next` 指针遍历链表。但找到了 `index` 的节点时就结束了，例如，当计数器是 0 的时候。

试试吧：

```swift
list.nodeAt(0)!.value    // "Hello"
list.nodeAt(1)!.value    // "World"
list.nodeAt(2)           // nil
```

为了好玩，我们也可以实现一个 `subscript` 方法：

```swift
  public subscript(index: Int) -> T {
    let node = nodeAt(index)
    assert(node != nil)
    return node!.value
  }
```

现在可以这样写了：

```swift
list[0]   // "Hello"
list[1]   // "World"
list[2]   // crash!
```

在 `list[2]` 的时候崩溃了，因为没有这个索引的节点。

到目前为止，我们已经写了将新节点添加到链表结尾的代码，但是这有点慢，因为先要找到最后一个节点（如果有一个 tail 指针的话就会快多了）。由于这个原因，如果列表中元素的顺序不重要的话，我们就应该在开头插入节点。这始终是 **O(1)** 的操作。

我们写个方法来在链表的开头插入新节点。首先，定义一个辅助方法：

```swift
  private func nodesBeforeAndAfter(index: Int) -> (Node?, Node?) {
    assert(index >= 0)
    
    var i = index
    var next = head
    var prev: Node?

    while next != nil && i > 0 {
      i -= 1
      prev = next
      next = next!.next
    }
    assert(i == 0)

    return (prev, next)
  }
```

这返回的是一个包含指定索引的节点以及它的前一个节点，如果有的话。除了在迭代过程中我们会保存前一个节点之外，循环特别像 `nodeAtIndex()`。

我们来看看一个例子。假如我们有下面的链表：

	head --> A --> B --> C --> D --> E --> nil

我们想要找到索引 3 前面和后面的节点。当开始循环的时候，`i = 3`, `next` 指向 `"A"`, 并且 `prev` 是 `nil`。

	head --> A --> B --> C --> D --> E --> nil
	        next

`i` 减 1，让 `prev` 指向 `"A"`, 然后将 `next` 移动到下一个节点, `"B"`：

	head --> A --> B --> C --> D --> E --> F --> nil
	        prev  next

再将 `i` 减 1 并且更新指针。现在 `prev` 指向 `B`，然后 `next` 指向 `C`：

	head --> A --> B --> C --> D --> E --> F --> nil
	              prev  next

正如你所见，`prev` 始终都是落后 `next` 一个位置。再做一次上面的操作 `i` 就变成 0 了，然后退出循环：

	head --> A --> B --> C --> D --> E --> F --> nil
	                    prev  next

循环之后的 `assert()` 检查在列表中是否有足够的节点。如果这个时候 `i > 0`，那么给定的索引就太大了。

> **注意：** 如果这篇文章中的循环对你来说没有任何感觉，那么请在纸上画一个链表然后走一下这个循环，就是我们在这里做的。

对于这个例子来说，方法返回 `("C", "D")`，因为 `"D"` 是索引 3 位置的节点，`"C"` 是在它之前的一个节点。

现在我们有了辅助方法，我们可以写插入节点的方法了：

```swift
  public func insert(value: T, atIndex index: Int) {
    let (prev, next) = nodesBeforeAndAfter(index)     // 1
    
    let newNode = Node(value: value)    // 2
    newNode.previous = prev
    newNode.next = next
    prev?.next = newNode
    next?.previous = newNode

    if prev == nil {                    // 3
      head = newNode
    }
  }
```

关于这个方法一些说明：

1. 首先，需要找到在哪里插入节点。调用辅助方法之后，`prev` 指向了前一个节点，`next` 是给定索引的当前节点。会在这两个节点之间插入新节点。注意，`prev` 可能为空（索引为 0），`next` 也可以能是 `nil`（索引正好是链表的大小），或者如果链表是空的话两个都是 `nil`。

2. 创建新的节点，连接 `previous` 和 `next` 指针。因为 局部的 `prev` 和 `next` 变量是可选的，可能为 `nil`，所以我们这里使用可选链。

3. 如果新节点插入到了链表的开头，我们需要更新 `head` 指针。（注意，如果链表有一个 `tail` 指针，如果 `next == nil` 的话，还需要更新 `tail` 指针，因为这意味着最后的元素变了。

试试吧：

```swift
list.insert("Swift", atIndex: 1)
list[0]     // "Hello"
list[1]     // "Swift"
list[2]     // "World"
```

为了验证这个能正常工作，也试试在链表的开头和结尾添加新节点吧，

> **注意：** `nodesBeforeAndAfter()` 和 `insert(atIndex)` 函数同样可以用于单项链表，因为我们不需要依赖节点的 previous 指针来找到前一个元素。

我们还需要做什么？当然是移除节点！首先，我们要 `removeAll()`，这非常简单：

```swift
  public func removeAll() {
    head = nil
  }
```

如果有一个 `tail` 指针，也要将它设置为 `nil`。

接下来我们要添加一些方法来移除单个节点。如果已经有了一个节点的引用，那么用 `removeNode()` 是最好的方法了，因为你不需要再遍历列表来找到节点。

```swift
  public func remove(node: Node) -> T {
    let prev = node.previous
    let next = node.next
    
    if let prev = prev {
      prev.next = next
    } else {
      head = next
    }
    next?.previous = prev
    
    node.previous = nil
    node.next = nil
    return node.value
  }
```

当把节点从列表移除的时候，就断开了节点和它的前一个和后一个节点的连接。为了使链表还是一个整体，就需要将前一个节点和后一个节点连接起来。

不要忘了 `head` 指针！如果要移除的是链表的第一个节点，那么需要更新 `head` 节点以使它指向下一个节点。（同样的，如果有 `tail` 指针并且要移除的是最后一个节点的话）。当然，如果没有节点了，那么 `head` 就是 `nil`。

试试吧：

```swift
list.remove(list.first!)   // "Hello"
list.count                     // 2
list[0]                        // "Swift"
list[1]                        // "World"
```

如果还没有节点的引用，可以用 `removeLast()` 或 `removeAt()`：

```swift
  public func removeLast() -> T {
    assert(!isEmpty)
    return remove(node: last!)
  }

  public func removeAt(_ index: Int) -> T {
    let node = nodeAt(index)
    assert(node != nil)
    return remove(node: node!)
  }
```

所有这些移除方法都会返回移除的节点的值。

```swift
list.removeLast()              // "World"
list.count                     // 1
list[0]                        // "Swift"

list.removeAt(0)          // "Swift"
list.count                     // 0
```

> **注意：** 对于单向链表来说，移除最后一个节点就有点复杂了。不能只是用 last 来找到链表的结尾，因为还需要一个指向倒数第二个节点的引用。相反的，用 `nodesBeforeAndAfter()` 辅助方法。如果链表有 `tail` 指针，那么 `removeLast()` 就非常快乐，但是记住要将 `tail` 指向前一个节点。

用我们的 `LinkedList` 类还可以做一些其他有趣的事情。有一个可读的调试输出会方便很多：

```swift
extension LinkedList: CustomStringConvertible {
  public var description: String {
    var s = "["
    var node = head
    while node != nil {
      s += "\(node!.value)"
      node = node!.next
      if node != nil { s += ", " }
    }
    return s + "]"
  }
}
```

会像这样打印链表：

	[Hello, Swift, World]

翻转一个链表怎么样，这样头就变成了尾，反之亦然？这有一个快速的方法：

```swift
  public func reverse() {
    var node = head
    while let currentNode = node {
      node = currentNode.next
      swap(&currentNode.next, &currentNode.previous)
      head = currentNode
    }
  }
```

这个循环遍历整个列表，然后简单的交换每个节点的 `next` 和 `previous` 指针。同时也将 head 指针移动到最后一个元素。（如果有一个尾指针的话，同样也要更新它。）得到的结果是这样的：

	         +--------+    +--------+    +--------+    +--------+
	tail --->|        |<---|        |<---|        |<---|        |---> nil
	         | node 0 |    | node 1 |    | node 2 |    | node 3 |
	 nil <---|        |--->|        |--->|        |--->|        |<--- head
	         +--------+    +--------+    +--------+    +--------+

数组有 `map()` 和 `filter()` 方法,链表没有理由没有。

```swift
  public func map<U>(transform: T -> U) -> LinkedList<U> {
    let result = LinkedList<U>()
    var node = head
    while node != nil {
      result.append(transform(node!.value))
      node = node!.next
    }
    return result
  }
```

可以这样使用它：

```swift
let list = LinkedList<String>()
list.append("Hello")
list.append("Swifty")
list.append("Universe")

let m = list.map { s in s.characters.count }
m  // [5, 6, 8]
```

下面是filter：

```swift
  public func filter(predicate: T -> Bool) -> LinkedList<T> {
    let result = LinkedList<T>()
    var node = head
    while node != nil {
      if predicate(node!.value) {
        result.append(node!.value)
      }
      node = node!.next
    }
    return result
  }
```

再加上一个简单的例子：

```swift
let f = list.filter { s in s.characters.count > 5 }
f    // [Universe, Swifty]
```

给读者的作业：这里 `map()` 和 `filter()` 的实现不是很快，因为他们是在新列表的最后 `append()` 新节点。回忆一下，追加是 **O(n)** 的，因为它需要扫描整个链表来找到最后的节点。你可以让这个变得更快吗？（提示：追踪添加的最后一个节点）。

## 另一种方法

目前为止你看到的 `LinkedList` 版本使用类来作为节点，因此有用到引用的概念。这没什么错，但是这使得它比 Swift 的其他比像 `Array` 和 `Dictionay` 这样的集合看起来重了一些。

用枚举来实现一个值语义的链表是可能的。这就会是下面这样：

```swift
enum ListNode<T> {
  indirect case node(T, next: ListNode<T>)
  case end
}
```

与基于类的版本最大的不同是，任何对链表的修改都创建一个 *新的拷贝* 来返回。是不是要这样要取决于你的应用。

[如果有要求的话，我会实现一个这样的版本]

## 一些其他要记住的事情

链表是灵活的但是大部分操作都是 **O(n)**。

当对链表做操作的时候，一定要小心地更新相应的 `next` 和 `previous` 指针，可能的话还有 `head` 和 `tail` 指针。如果你搞砸了的话，你的链表就会不对了，你的程序可能就会在某时崩溃。一定要小心！

当处理链表的时候，可以经常使用递归：处理第一个节点然后递归地对剩下的链表调用这个方法。当没有下一个元素的时候就结束了。这就是为什么链表是像 LISP 这样的函数编程语言的基础。

*作者：Matthijs Hollemans 翻译：Daisy*


