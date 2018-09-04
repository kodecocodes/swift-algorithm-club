# 栈 Stack

> 这个主题已有的[教程](https://www.raywenderlich.com/149213/swift-algorithm-club-swift-stack-data-structure)

栈就像是一个数组，但功能有所限制。你只能通过`push`将新元素添加到栈顶，通过`pop`从栈顶移除元素，或通过`peek`查看栈顶元素（这个操作不会移除栈顶元素）。

为什么你需要使用栈来做这些操作呢？因为在许多算法中，你随时需要将元素添加到一个临时列表中，使用完之后再将它们从列表中移除。通常，添加和移除这些元素的顺序是很重要的。

栈遵守后进先出的规则(LIFO)。你最后`push`的元素，将会在`pop`时第一个被移除。（有一个非常相似的数据结构，那就是[队列]（../ Queue /），它遵守先进先出(FIFO)的规则。）

例如，我们在栈里面`push`一个数值元素：

```swift
stack.push(10)
```

这时栈里面的内容现在是`[ 10 ]`，然后我们再`push`另一个数值元素：

```swift
stack.push(3)
```

这时栈里面的内容变成了`[ 10, 3 ]`。接下来我们再`push`一个数值元素：

```swift
stack.push(57)
```

这个时候栈里面的内容是`[ 10, 3, 57 ]`。现在，我们从栈里面`pop`一个数值元素：

```swift
stack.pop()
```

这个操作会返回一个数值元素`57`，因为这是我们最后`push`到栈里的元素，现在栈里面的内容又变成了`[ 10, 3 ]`。

```swift
stack.pop()
```

这个操作会返回一个数值元素`3`，以此类推。如果栈最后为空了，我们还继续执行`pop`操作，这里栈将会返回一个`nil`，在某些实现中也可能会抛出一条错误信息"stack underflow"。

在Swift中很容易就可以创建一个栈。只需要对数组进行一层简单的封装，你就可以实现`push`，`pop`，`peek`操作：

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

注意：`push`操作是将一个新的元素添加到数组的末尾，而不是开头。因为在数组的开头执行插入操作的开销是很大的，这是一个**O(n)**时间复杂度的操作，它需要移动内存中已经存在的每一个数组元素。而在数组的末尾执行插入操作的时间复杂度只有**O(1)**，不管数组里面有多少元素，它总是消耗相同的时间。

Fun fact about stacks: Each time you call a function or a method, the CPU places the return address on a stack. When the function ends, the CPU uses that return address to jump back to the caller. That's why if you call too many functions -- for example in a recursive function that never ends -- you get a so-called "stack overflow" as the CPU stack has run out of space.
关于栈，我们发现一个有趣的实际应用场景：每一次我们调用一个函数或者一个方法，CPU会将这个函数的地址放到栈中。当这个函数执行完，CPU使用这个函数地址跳转到函数被调用的地方。这就是为什么当你调用的函数数量过多的时候（例如一次无限的递归调用），会收到一个 所谓的"stack overflow"错误信息，因为CPU的栈空间已经被用完了。

翻译: [ChengWei](https://github.com/WeiweiYuan810) 
[原文地址](https://github.com/raywenderlich/swift-algorithm-club/blob/master/Stack/README.markdown)
