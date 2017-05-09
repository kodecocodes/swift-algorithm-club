# 栈

栈类似于数组，但是存取操作会受到限制。只能从栈顶压入（push）元素；从栈顶弹出（pop）元素；获取（peek）元素，但不弹出。

为什么要这样做？在许多算法的实现中，经常会需要将一些数据放到一个临时的列表中，之后又要从这个队列中将他们取出来。通常加入和取出元素的顺序非常重要。

栈的操作顺序是后进先出。最后加入的元素会第一个被取出。（有一个非常类似的数据结构，[队列](../Queue/README-CN.markdown)，是先进先出的）。

例如，将一个数字假如到栈中：

```swift
stack.push(10)
```

现在栈是 `[ 10 ]`。假如下一个数字：

```swift
stack.push(3)
```

现在栈是 `[ 10， 3 ]`。假如下一个数字：

```swift
stack.push(57)
```

栈现在是 `[ 10, 3, 57 ]`。现在我们要取出栈里的数字：

```swift
stack.pop()
```

它会返回 `57`, 因为这是我们最新假如到栈里的数字。现在栈又是 `[10, 3]` 了。

```swift
stack.pop()
```

这会返回的是 `3`, 依此类推. 如果栈空了就会返回 `nil` 或者在一些其他实现中会抛出一个栈下溢的错误消息。

在 Swift 中要创建一个栈非常容易。只是一个对数组的封装，然后我们只允许它push、pop和peek栈顶的元素：

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

注意，压入（push）操作是在数组的最后加入元素，而不是开头。在数据的开头插入一个元素是很昂贵的，是一个 **O( n )** 操作，因为它会导致数组中所有的元素都要改变在内存中的位置。在最后插入的话就是  **O( 1 )**，不管数组多大，它花费的时间都是一样的。

关于栈有趣的地方在于：每次调用一个函数或者方法的时候，CPU 都会将返回地址压入一个栈中，当函数结束时，CPU 用那个返回地址跳回到调用者。当你调用了很多函数——例如，一个永远不结束的递归函数——的时候，你会得到一个叫做“栈溢出”的错误，这是因为 CPU 的栈没有空间了。

*作者： Mattijs Hollemans 译者：Daisy*


