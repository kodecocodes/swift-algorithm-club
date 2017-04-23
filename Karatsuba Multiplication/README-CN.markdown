# Karatsuba 乘法

目标：快速将两个数字相乘

## 长乘法

在小学我们就学习了如何通过长乘法将两个数相乘。先让我们来试试吧！

### 例 1：用长乘法将 1234 和 5678 相乘

	    5678
	   *1234
	  ------
	   22712
	  17034-
	 11356--
	 5678---
	--------
	 7006652

长乘法的问题是什么呢！想想我们的目标。要 *快速地* 乘以两个数字。长乘法有点慢！(**O(n^2)**)

可以从长乘法的实现里看到 (**O(n^2)**) 是怎么来的：

```swift
// Long Multiplication
func multiply(_ num1: Int, by num2: Int, base: Int = 10) -> Int {
  let num1Array = String(num1).characters.reversed().map{ Int(String($0))! }
  let num2Array = String(num2).characters.reversed().map{ Int(String($0))! }
  
  var product = Array(repeating: 0, count: num1Array.count + num2Array.count)

  for i in num1Array.indices {
    var carry = 0
    for j in num2Array.indices {
      product[i + j] += carry + num1Array[i] * num2Array[j]
      carry = product[i + j] / base
      product[i + j] %= base
    }
    product[i + num2Array.count] += carry
  }
  
  return Int(product.reversed().map{ String($0) }.reduce("", +))!
}
```

两个 for 循环是罪魁祸首！通过对比每一个数字（因为它是必须的！）让运行时间达到了 **O(n^2)**。所以长乘法可能不是最好的算法。我们还可以做的更好吗？

## Karatsuba 乘法

Karatsuba 算法是由 Anatoly Karatsuba 发现的，并且在 1962 年发表了。Karatsuba 发现可以通过用三个小数和一些加法和减法来计算两个大数的乘法。

对于两个数字 x，y。有 m <= n：

	x = a*10^m + b
	y = c*10^m + d

现在，可以这样做：

	x*y = (a*10^m + b) * (c*10^m + d)
	    = a*c*10^(2m) + (a*d + b*c)*10^(m) + b*d

这个在 19 世纪就已经很刘姓了。问题就是这个方法需要 4 个乘法 （`a*c`, `a*d`, `b*c`, `b*d`）。Karatsuba 的观点是只需要三个 （`a*c`, `b*d`, `(a+b)*(c+d)`）。现在，一个完美的有用的问题就是 “这怎么可能！？！” 下面是计算过程：

        (a+b)*(c+d) - a*c - b*d  = (a*c + a*d + b*c + b*d) - a*c - b*d
                                 = (a*d + b*c)

非常酷，对不对？

下面是完整的实现。递归算法在 m = n/2 的时候就非常有效率了。

```swift
// Karatsuba Multiplication
func karatsuba(_ num1: Int, by num2: Int) -> Int {
  let num1Array = String(num1).characters
  let num2Array = String(num2).characters
  
  guard num1Array.count > 1 && num2Array.count > 1 else {
    return num1*num2
  }
  
  let n = max(num1Array.count, num2Array.count)
  let nBy2 = n / 2
  
  let a = num1 / 10^^nBy2
  let b = num1 % 10^^nBy2
  let c = num2 / 10^^nBy2
  let d = num2 % 10^^nBy2
  
  let ac = karatsuba(a, by: c)
  let bd = karatsuba(b, by: d)
  let adPlusbc = karatsuba(a+b, by: c+d) - ac - bd
  
  let product = ac * 10^^(2 * nBy2) + adPlusbc * 10^^nBy2 + bd
  
  return product
}
```

这个算法的运行时间如何呢？所有这些额外的工作是否值得呢？我们可以用大师定理来回答这个问题。这就将我们带向了 `T(n) = 3*T(n/2) + c*n + d`，其中 c 和 d是一些常量。得出运行时间是 **O(n^log2(3))** （因为 3 > 2^1），接近 **O(n^1.56)**。是不是更好了！

### 例 2： 用 Karatsuba 乘法将 1234 和 5678 相乘

	m = 2
	x = 1234 = a*10^2 + b = 12*10^2 + 34
	y = 5678 = c*10^2 + d = 56*10^2 + 78

	a*c = 672
	b*d = 2652
	(a*d + b*c) = 2840
	
	x*y = 672*10^4 + 2840*10^2 + 2652
	    = 6720000 + 284000 + 2652
	    = 7006652	
 
## 资源

[维基百科] (https://en.wikipedia.org/wiki/Karatsuba_algorithm)

[WolframMathWorld] (http://mathworld.wolfram.com/KaratsubaMultiplication.html) 

[Master Theorem] (https://en.wikipedia.org/wiki/Master_theorem)

*作者：Richard Ash 翻译：Daisy*


