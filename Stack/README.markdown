# 栈
> 举个应用的[栗子](https://www.raywenderlich.com/149213/swift-algorithm-club-swift-stack-data-structure)

栈类似于数组，但是限制了存取操作的灵活性。栈只允许使用者从栈顶**压入(push)**元素；从栈顶**弹出(pop)**元素；**取得(peek)**栈顶元素，但不弹出。

这样的限制有什么意义呢？在很多算法的实现中，你可能需要将某些对象放到一个临时的列表中，之后再将其取出。通常加入和取出元素的顺序非常重要。

栈可以保证元素存入和取出的顺序是后进先出(last-in first-out, LIFO)的。栈中弹出的元素总是你最后放进去的那个。另外一个非常类似的数据结构是[队列](../Queue/)，它是一个先进先出(first-in, first-out, FIFO)的结构。

举例来说，我们先将一个数字压入栈中：

```swift
stack.push(10)
```

栈现在是 `[10]`。压入下一个数字：

```swift
stack.push(3)
```

栈现在是 `[10, 3]`。再压入一个数字：

```swift
stack.push(57)
```

栈现在是 `[10, 3, 57]`。现在把栈顶的数字弹出来：

```swift
stack.pop()
```

这行代码返回 `57`，因为它是我们最后压入的元素。现在栈又变成了 `[10, 3]`。

```swift
stack.pop()
```

这行代码返回 `3`，以此类推。如果栈空了，弹栈操作将返回 `nil`，在有些实现中，会触发一个 `stack underflow` 错误消息。

栈在 Swift 中的实现非常容易。只需要包装一下自带的数组，将存取功能限制为 pop、push 和 peek 即可。

```swift
public struct Stack<T> {
  fileprivate var array = [T]()

  public var isEmpty: Bool {
    return array.isEmpty
  }

  public var count: Int {
    return array.count
  }

  public mutating func push(_ element: T) {
    array.append(element)
  }

  public mutating func pop() -> T? {
    return array.popLast()
  }

  public var top: T? {
    return array.last
  }
}

```

注意到，压栈操作是将新元素压入数组的尾部，而不是头部。在数组的头部插入元素是一个很耗时的操作，它的时间复杂度为 **O(n)**，因为需要将现有元素往后移位为新元素腾出空间。而在尾部插入元素的时间复杂度为 **O(1)**；无论数组有多少元素，这个操作所消耗的时间都是一个常量。

关于栈的有趣知识：每次你调用函数或方法，CPU 都会将函数返回地址压入到运行栈中。当这个函数执行结束的时候，CPU 将返回地址从栈中取出，并据此返回到函数被调用的位置。所以，如果不断地调用太多的函数(例如死递归函数)，就会得到一个所谓的“栈溢出(stack overflow)” 错误，因为 CPU 运行栈没有空间了。

*作者：Matthijs Hollemans；译者：KSCO*
