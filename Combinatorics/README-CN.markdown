# 排列

*排列* 是对一个集合中的对象特定布局。例如，如果我们有字母表的前五个字母，那么这就是一种排列：

	a, b, c, d, e

这是另外一种排列：

	b, e, d, a, c

对于一个有 `n` 个对象的集合，有 `n!` 中可能的排列方式，`!` 表示阶乘。所以对于有 5 个字母的集合，可以算出总共的排列方式有：

	5! = 5 * 4 * 3 * 2 * 1 = 120

有六个元素的集合有 `6! = 720` 种排列。对于十个元素，就有 `10! = 3,628,800`。加起来真是很快啊！

`n!` 是从哪里来的呢？逻辑是下面这样的：我们有五个字母的集合想要按一定顺序排列他们。为了实现这个，就需要一个个地拿字母。开始的时候，你有五个选择：`a, b, c, d, e`。这就有 5 中可能性。

拿了第一个字母之后，就只剩下了四个字母可以选择。这就有 `5 * 4 = 20` 种可能：

	a+b    b+a    c+a    d+a    e+a
	a+c    b+c    c+b    d+b    e+b
	a+d    b+d    c+d    d+c    e+c
	a+e    b+e    c+e    d+e    e+d

选择了第二个字母之后，就只有三个字母可以选择了。等等等等...当拿最后一个字母的时候，就没有任何选择了，因为只剩下了一个字母。这就是为什么总的可能性是 `5 * 4 * 3 * 2 * 1`。

用 Swift 来计算阶乘：

```swift
func factorial(_ n: Int) -> Int {
  var n = n
  var result = 1
  while n > 1 {
    result *= n
    n -= 1
  }
  return result
}
```

在 playground 里试试：

```swift
factorial(5)   // returns 120
```

注意，`factorial(20)` 是用这个能计算的最大数字，否则就要整数溢出了。

假如我们只想从五个字母的集合中选择三个。那么有多少种可能呢？好吧，这个跟之前是一样的工作方式，除了我们在第三步就停止之外。所以现在可能性是 `5 * 4 * 3 = 60`。

这个的公式是：

	             n!
	P(n, k) = --------
	          (n - k)!

`n` 是集合的大小，`k` 是想要选择的组的大小。在我们的例子中，`P(5, 3) = 5! / (5 - 3)! = 120 / 2 = 60`。

可以用之前的 `factorial()` 函数来实现这个，但是有一个问题。还记得 `factorial(20)` 是它可以处理的最大数吗，所以绝对不能计算像 `P(21, 3)` 这样的数据。

下面是一个可以处理大数的算法：

```swift
func permutations(_ n: Int, _ k: Int) -> Int {
  var n = n
  var answer = n
  for _ in 1..<k {
    n -= 1
    answer *= n
  }
  return answer
}
```

试试吧：

```swift
permutations(5, 3)   // returns 60
permutations(50, 6)  // returns 11441304000
permutations(9, 4)   // returns 3024
```

这个方法利用了下面的代数原理：

	          9 * 8 * 7 * 6 * 5 * 4 * 3 * 2 * 1
	P(9, 4) = --------------------------------- = 9 * 8 * 7 * 6 = 3024
	                          5 * 4 * 3 * 2 * 1

分母抵消了分子的一部分，所以没有必要再执行一个除法并且不用处理可能很大的中间结果。

然而，对于能计算的数字还是有限制；例如计算有 30 个对象的大小为 15 的组的数字 -- 即 `P(30, 15)` -- 结果是巨大的并且超出了 Swift 的范围。哈，你可能没想到它会这么大，但是组合就是这么好玩。

## 生成排列

目前为止我们计算了对于一个给定集合有多少种排列方式，但是如何没创造所有这些排列呢？

下面是一个 Niklaus Wirth 写的递归算法：

```swift
func permuteWirth<T>(_ a: [T], _ n: Int) {
  if n == 0 {
    print(a)   // display the current permutation
  } else {
    var a = a
    permuteWirth(a, n - 1)
    for i in 0..<n {
      swap(&a[i], &a[n])
      permuteWirth(a, n - 1)
      swap(&a[i], &a[n])
    }
  }
}
```

像下面这样使用：

```swift
let letters = ["a", "b", "c", "d", "e"]
permuteWirth(letters, letters.count - 1)
```

它会在调试输出里打印输入数组的所有排列方式：

```swift
["a", "b", "c", "d", "e"]
["b", "a", "c", "d", "e"]
["c", "b", "a", "d", "e"]
["b", "c", "a", "d", "e"]
["a", "c", "b", "d", "e"]
...
```

就像我们之前看到的，会有 120 个这样的结果。

这个算法是如何工作的？好问题！让我们来一步步看看一个只有三个元素的例子是如何实现的。输入数组是：

	[ "x", "y", "z" ]

像这样调用它：

```swift
permuteWirth([ "x", "y", "z" ], 2)
```

注意，参数 `n` 是比数组元素要少 1 的！

调用 `permuteWirth()` 之后，马上就用 `n - 1` 递归地调用自己。并且马上有用 `n = 0` 再一次递归地调用自己。调用树就像是这样的：

```swift
permuteWirth([ "x", "y", "z" ], 2)
	permuteWirth([ "x", "y", "z" ], 1)
		permuteWirth([ "x", "y", "z" ], 0)   // prints ["x", "y", "z"]
```

当 `n` 等于 0 的时候，输出当前的数组，这个时候它还没有改变。递归还只是在最基本的情况下，所以现在我们要继续回到上一级并且进入 `for` 循环。

```swift
permuteWirth([ "x", "y", "z" ], 2)
	permuteWirth([ "x", "y", "z" ], 1)   <--- back to this level
	    swap a[0] with a[1]
        permuteWirth([ "y", "x", "z" ], 0)   // prints ["y", "x", "z"]
	    swap a[0] and a[1] back
```

将 `"y"` 和 `"x"` 互换并且打印结果。这时就结束了这个层级的递归调用并且回到上一级。这次我们要做 `for` 循环里的两次递归调用，因为 `n = 2`。第一个迭代是这样的：

```swift
permuteWirth([ "x", "y", "z" ], 2)   <--- back to this level
    swap a[0] with a[2]
	permuteWirth([ "z", "y", "x" ], 1)
        permuteWirth([ "z", "y", "x" ], 0)   // prints ["z", "y", "x"]
	    swap a[0] with a[1]
        permuteWirth([ "y", "z", "x" ], 0)   // prints ["y", "z", "x"]
	    swap a[0] and a[1] back
    swap a[0] and a[2] back
```

第二个迭代是这样的：

```swift
permuteWirth([ "x", "y", "z" ], 2)
    swap a[1] with a[2]                 <--- second iteration of the loop
	permuteWirth([ "x", "z", "y" ], 1)
        permuteWirth([ "x", "z", "y" ], 0)   // prints ["x", "z", "y"]
	    swap a[0] with a[1]
        permuteWirth([ "z", "x", "y" ], 0)   // prints ["z", "x", "y"]
	    swap a[0] and a[1] back
    swap a[1] and a[2] back
```

总结一下，第一次它交换了这些项：

	[ 2, 1, - ]

然后是这些：

	[ 3, -, 1 ]

递归地，又交换前两个：


	[ 2, 3, - ]

然后就回到第一步交换这些：

	[ -, 3, 2 ]

最后是这两个：

	[ 3, 1, - ]

当然，数组越大，就要执行越多的交换并且递归也变得更深。

如果上面的还不够清除的话，我建议你在 playground 里试试。这就是 playground 的作用。:-)

为了好玩，下面是 Robert Sedgewick 的一个算法：

```swift
func permuteSedgewick(_ a: [Int], _ n: Int, _ pos: inout Int) {
  var a = a
  pos += 1
  a[n] = pos
  if pos == a.count - 1 {
    print(a)              // display the current permutation
  } else {
    for i in 0..<a.count {
      if a[i] == 0 {
        permuteSedgewick(a, i, &pos)
      }
    }
  }
  pos -= 1
  a[n] = 0
}
```

像这样来用它：

```swift
let numbers = [0, 0, 0, 0]
var pos = -1
permuteSedgewick(numbers, 0, &pos)
```

数组必须一开始都是 0。 0 是用来表示在每一个递归的层级还有更多需要做的。

Sedgewick 算法阿德输出是这样的：

```swift
[1, 2, 3, 0]
[1, 2, 0, 3]
[1, 3, 2, 0]
[1, 0, 2, 3]
[1, 3, 0, 2]
...
```

它只能处理数字，但这些可以作为实际需要排列的数组的索引，所以它和 Wirth 的算法一样有用。

自己看看这个算法是如何工作的吧！

## 组合

组合是和排列一样但是顺序不重要。下面是 `k` `l` `m` 的六种不同的排列，但是它们都是同样的组合：

	k, l, m      k, m, l      m, l, k
	l, m, k      l, k, m      m, k, l

所以对于 3 的大小来说只有一种组合方式，如果想要查找 2 大小的组合，就可以有三种：

	k, l      (is the same as l, k)
	l, m      (is the same as m, l)
	k, m      (is the same as m, k)

`C(n, k)` 方法是计算从 `n` 里面挑出 `k` 个元素有多少种可能。这就是为什么叫做 “n 选择 k”。（这个数字有一个非常华丽的数学术语叫 “二项式系数”。）

`C(n, k)` 的公式是：

	               n!         P(n, k)
	C(n, k) = ------------- = --------
	          (n - k)! * k!      k!

就像你看到的，我们可以从 `P(n, k)` 的公式推导出来。排列总是比组合多。将排列的数字除以 `k!`，因为 `k!` 种的排列组合有相同的组合。

上面我展示了 `k` `l` `m` 的排列是 6，但是如果从这些字母里只选择两个的话就有 3 种组合方式。如果我们用公式的话也可以得到同样的结果。我们要计算 `C(3, 2)`，因为我们是从有 3 个元素的集合里选择 2 个。

	          3 * 2 * 1    6
	C(3, 2) = --------- = --- = 3
	           1! * 2!     2

下面是一个简单的计算 `C(n, k)` 的方法：

```swift
func combinations(_ n: Int, choose k: Int) -> Int {
  return permutations(n, k) / factorial(k)
}
```

这样来使用它：

```swift
combinations(28, choose: 5)    // prints 98280
```

因为在里面用到了 `permutations()` 和 `factorial()` 方法，所以依然受到能得到的最大数的限制。例如，`combinations(30, 15)` 只有 `155,117,520`，但是因为中间结果超出了 64 位整数，不能用给定的方法来计算它。

有一个更快的方法可以计算 `C(n, k)`，只要 **O(k)** 的时间和 **O(1)** 的额外空间。背后的思想就是 `C(n, k)` 的公式：

                   n!                      n * (n - 1) * ... * 1
    C(n, k) = ------------- = ------------------------------------------
              (n - k)! * k!      (n - k) * (n - k - 1) * ... * 1 * k!

在减小分数厚，就得到了下面的公式：

                   n * (n - 1) * ... * (n - k + 1)         (n - 0) * (n - 1) * ... * (n - k + 1)
    C(n, k) = --------------------------------------- = -----------------------------------------
                               k!                          (0 + 1) * (1 + 1) * ... * (k - 1 + 1)

可以像下面这样实现这个公式：

```swift
func quickBinomialCoefficient(_ n: Int, choose k: Int) -> Int {
  var result = 1
  for i in 0..<k {
    result *= (n - i)
    result /= (i + 1)
  }
  return result
}
```

这个算法可以比之前的方法计算更大的数字。与计算整个分子（可能是一个很大的数字）然后在除以阶乘（可能也是一个很大的数字）不同的是，在每一步都进行除法，这就是使得临时结果不会很快变得很大。

下面是如何利用这个改进的算法：

```swift
quickBinomialCoefficient(8, choose: 2)     // prints 28
quickBinomialCoefficient(30, choose: 15)   // prints 155117520
```

这个新方法很快但是还是受到能得到的最大数的限制。计算 `C(30, 15)` 没有任何问题，但是像 `C(66, 33)` 这样的依然会导致整数溢出。

下面是使用动态编程来客服需要计算阶乘和做除法的算法。是基于 Pascal 三角形的：

	0:               1
	1:             1   1
	2:           1   2   1
	3:         1   3   3   1
	4:       1   4   6   4   1
	5:     1   5  10   10  5   1
	6:   1   6  15  20   15  6   1

下一行的数字是由上一行的两个数字想加得到的。例如，在行 6，数字 15 是由第 5 行的 5 和 10 想加得到的。这些数字就叫做二项式系数，并且他们与 `C(n, k)` 是一样的。

例如，对于行 6：

	C(6, 0) = 1
	C(6, 1) = 6
	C(6, 2) = 15
	C(6, 3) = 20
	C(6, 4) = 15
	C(6, 5) = 6
	C(6, 6) = 1

下面的代码计算了 Pascal 三角形来找到要计算的 `C(n, k)`：

```swift
func binomialCoefficient(_ n: Int, choose k: Int) -> Int {
  var bc = Array(repeating: Array(repeating: 0, count: n + 1), count: n + 1)

  for i in 0...n {
    bc[i][0] = 1
    bc[i][i] = 1
  }

  if n > 0 {
    for i in 1...n {
      for j in 1..<i {
        bc[i][j] = bc[i - 1][j - 1] + bc[i - 1][j]
      }
    }
  }

  return bc[n][k]
}
```

算法本身很简单：第一个循环用 1 填充三角形的外边缘。另一个循环通过将上一行的两个数字想加来计算三角形里面的数字。

现在你可以计算 `C(66, 33)` 而没有任何问题了：

```swift
binomialCoefficient(66, choose: 33)   // prints a very large number
```

你可能想知道计算排列和组合的时候重点是什么呢，但是很多算法问题实际上是伪装的组合问题。可能经常需要查找数据里的所有可能的组合来找到那个是正确的解决方法。如果这意味这你要搜索整个 `n!` 种可能的话，你可能就会考虑不同的方法了 -- 正如你所见，这些数字很快就变得非常大！

## 参考

Wirth 和 Sedgewick 的排列算法和计算排列和组合的代码是基于 Dr.Dobb 的杂志里的 算法谷，1993年六月。二项式系数的动态编程算法是来自 Skiena 的算法设计手册。

*作者Matthijs Hollemans and [Kanstantsin Linou](https://github.com/nuts23) 翻译：Daisy*


