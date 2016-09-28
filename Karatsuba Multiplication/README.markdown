# Karatsuba Multiplication

Goal: To quickly multiply two numbers together

## Long Multiplication

In grade school we all learned how to multiply two numbers together via Long Multiplication. So let's try that first!

Example 1: Multiply 1234 by 5678 using Long Multiplication

	    5678
	   *1234
	  ------
	   22712
	  17034-
	 11356--
	 5678---
	--------
	 7006652

So what's the problem with long multiplication? Speed. Long Multiplication runs in **O(n^2)**. 

You can see where the **O(n^2)** comes from in the implementation for Long Multiplication:

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

The double for loop is the culprit! So Long Multiplication might not be the best algorithm after all. Can we do better?

## Karatsuba Multiplication

The Karatsuba Algorithm was discovered by Anatoly Karatsuba and published in 1962. Karatsuba discovered that you could compute the product of two large numbers using three smaller products and some addition and subtraction.

For two numbers x, y, where m <= n:

	x = a*10^m + b
	y = c*10^m + d

Now, we can say:

	x*y = a*c*10^(2m) + (a*d + b*c)*10^(m) + b*d

We can compute this function recursively, and that's what makes Karatsuba Multiplication fast.

```swift
let ac = karatsuba(a, by: c)
let bd = karatsuba(b, by: d)
let adPlusbc = karatsuba(a+b, by: c+d) - ac - bd
```

The last recursion is interesting. Normally, you'd think we would have to run four recursions to find the product `x*y` (`a*c`, `a*d`, `b*c`, `b*d`). However, Karatsuba realized that you only need three recursions, and some addition and subtraction. Here's the math:

	(a+b)*(c+d) - a*c - b*c  = (a*c + a*d + b*c + b*d) - a*c - b*c
		    		 = (a*d + b*c)

Pretty cool, huh?

Here's the full implementation

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

The run time for this algorithm is about **O(n^1.56)** which is better than the **O(n^2)** for Long Multiplication. 

Example 2: Multiply 1234 by 5678 using Karatsuba Multiplication

	m = 2
	x = 1234 = a*10^2 + b = 12*10^2 + 34
	y = 5678 = c*10^2 + d = 56*10^2 + 78

	a*c = 672
	b*d = 2652
	(a*d + b*c) = 2840
	
	x*y = 672*10^4 + 2840*10^2 + 2652
	    = 6720000 + 284000 + 2652
	    = 7006652	
 
## Resources

[Wikipedia] (https://en.wikipedia.org/wiki/Karatsuba_algorithm)

[WolframMathWorld] (http://mathworld.wolfram.com/KaratsubaMultiplication.html) 

*Written for Swift Algorithm Club by Richard Ash*
