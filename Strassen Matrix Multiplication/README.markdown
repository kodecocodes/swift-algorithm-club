# Strassen Matrix Multiplication

## Goal
+ To quickly perform a matrix multiplication operation on two matricies

## What is Matrix Multiplication??

> Note: If you are already familiar with Linear Algebra/Matrix Multiplication, feel free to skip this section

Before we begin, you may ask what is matrix multiplication? Great question! It is **NOT** multiplying two matricies term-by-term. Matrix multiplication is a mathematical operation that combines two matricies into a single one. Sounds like multiplying term-by-term huh? It's not... our lives would be much easier if it were. To see how matrix multiplcation works, let's look at an example.

### Example: Matrix Multiplication

```
matrix A = |1 2|, matrix B = |5 6|
           |3 4|             |7 8|
	
A * B = C
	
|1 2| * |5 6| = |1*5+2*7 1*6+2*8| = |19 22|
|3 4|   |7 8|   |3*5+4*7 3*6+4*8|   |43 50|
```

What's going on here? To start, we're multiplying matricies A & B. Our new matrix, C's, elements `[i, j]` are determined by the dot product of the first matrix's ith row and the second matrix's jth column. See [here](https://www.khanacademy.org/math/linear-algebra/vectors-and-spaces/dot-cross-products/v/vector-dot-product-and-vector-length) for a refresher on the dot product.

So the upper left element `[i=1, j=1]` of our new matrix is a combination of A's 1st row and B's 1st column.

	A's first row = [1, 2]
	B's first column = [5, 7]

	[1, 2] dot [5, 7] = [1*5 + 2*7] = [19] = C[1, 1]

Now let's try this for `[i=1, j=2]`. Because `i=1` and `j=2`, this will represent the upper right element in our new matrix, C.

	A's first row = [1, 2]
	B's second column = [6, 8]
	
	[1, 2] dot [6, 8] = [1*6 + 2*8] = [22] = C[1, 2]

If we do this for each row & column of A & B we'll get our result matrix C!

Here's a great graphic that visually shows you what's going on.

![](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Matrix_multiplication_principle.svg/1024px-Matrix_multiplication_principle.svg.png)

[Source](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Matrix_multiplication_principle.svg/1024px-Matrix_multiplication_principle.svg.png)


## Matix Multiplication Algorithm

So how do we implement matrix multiplication in an algoirthm? We'll start with the basic version and from there move on to Strassen's Algorithm.

+ [Basic Version](#basic-version)
+ [Strassen's Algorithm](#strassens-algorithm)

### Basic Version

Remember the method we used to solve matrix multiplication [above](#what-is-matrix-multiplication??)? Let's try to implement that first! We first assert that the two matricies are the right size. 

`assert(A.columns == B.rows, "Two matricies can only be matrix mulitiplied if one has dimensions mxn & the other has dimensions nxp where m, n, p are in R")`

> **NOTE:** A's # of columns HAS to equal B's # of rows for matrix multiplication to work

Next, we loop over A's columns and B's rows. Because we know both A's columns & B's rows are the same length, we set that length equal to `n`.

```swift
for i in 0..<n {
  for j in 0..<n {
```

Then, for each row in A and column in B, we take the dot product of the ith row in A with the jth column in B and set that result equal to the `[i, j]` element in C. Or `C[i, j]`.

```swift
for k in 0..<n {
  C[i, j] += A[i, k] * B[k, j]
}
```

Finally, we return our new matrix C!

Here's the full implementation:

```swift
public func matrixMultiply(by B: Matrix<T>) -> Matrix<T> {
  let A = self
  assert(A.columns == B.rows, "Two matricies can only be matrix mulitiplied if one has dimensions mxn & the other has dimensions nxp where m, n, p are in R")
  let n = A.columns
  var C = Matrix<T>(rows: A.rows, columns: B.columns)
    
  for i in 0..<n {
    for j in 0..<n {
      for k in 0..<n {
        C[i, j] += A[i, k] * B[k, j]
      }
    }
  }
    
  return C
}
```

This algorithm has a runtime of **O(n^3)**. The **O(n^3)** comes from the three `for` loops. Two from the loop over the rows & columns and one from the dot product!

Now, **O(n^3)** is not very fast and a great question we should ask is can we do better? Indeed we can!

### Strassens Algorithm

Volker Strassen first published his algorithm in 1969. It was the first algorithm to prove that the basic **O(n^3)** runtime was not optiomal. 

The basic idea behind Strassen's algorithm is to split A & B into 8 submatricies and then recursively compute the submatricies of C. This strategy is called *Divide and Conquer*.

```
matrix A = |a b|, matrix B = |e f|
           |c d|             |g h|
```

*There will be 8 recursive calls:*

1. a * e
2. b * g
3. a * f 
4. b * h
5. c * e
6. d * g 
7. c * f 
8. d * h

We then use these results to compute C's submatricies.

	matrix C = |ae+bg af+bh|
			   |ce+dg cf+dh| 

![http://d1hyf4ir1gqw6c.cloudfront.net//wp-content/uploads/strassen_new.png](http://d1hyf4ir1gqw6c.cloudfront.net//wp-content/uploads/strassen_new.png)

This step alone, however, doesn't help our runtime at all. Using the [Master Theorem](https://en.wikipedia.org/wiki/Master_theorem) with `T(n) = 8T(n/2) + O(n^2)` we still get a runtime of `O(n^3)`.

Strassen's insight was that we don't actually need **8** recursive calls to complete this process. We can finish the call with **7** recursive calls and a little bit of addition and subtraction.

Strassen's **7** calls are as follows:

1. a * (f - h)
2. (a + b) * h
3. (c + d) * e
4. d * (g - e)
5. (a + d) * (e + h)
6. (b - d) * (g + h)
7. (a - c) * (e + f)

Now we can compute our new matrix C's new quardents!

```
matrix C = |p5+p4-p2+p6    p1+p2   |
           |   p3+p4    p1+p5-p3-p7|    
```

A great reaction right now would be !!??!?!?!!?! How does this even work??

Let's prove it!

**First** Submatrix:

```
p5+p4-p2+p6 = (a+d)*(e+h) + d*(g-e) - (a+b)*h + (b-d)*(g+h)
            = (ae+de+ah+dh) + (dg-de) - (ah+bh) + (bg-dg+bh-dh)
            = ae+bg ✅
```
				
Exactly what we got the first time!

Now let's prove the others.

**Second** submatrix:

```
p1+p2 = a*(f-h) + (a+b)*h
      = (af-ah) + (ah+bh)
      = af+bh ✅
```
		  
**Third** submatrix:

```
p3+p4 = (c+d)*e + d*(g-e)
      = (ce+de) + (dg-de)
      = ce+dg ✅
```

**Fourth** submatrix: 

```
p1+p5-p3-p7 = a*(f-h) + (a+d)*(e+h) - (c+d)*e - (a-c)*(e+f)
            = (af-ah) + (ae+de+ah+dh) -(ce+de) - (ae-ce+af-cf)
            = cf+dh ✅
```

Great! The math checks out!

Here's the process in action.

![](http://d1hyf4ir1gqw6c.cloudfront.net//wp-content/uploads/stressen_formula_new_new.png)

[Source](http://www.geeksforgeeks.org/strassens-matrix-multiplication/)

#### Implementation

Ok so now to the implementation. We'll start with the same first step from the basic implementation. We need to assert that A's # of columns are equal to B's number of rows.

	assert(A.columns == B.rows, "Two matricies can only be matrix mulitiplied if one has dimensions mxn & the other has dimensions nxp where m, n, p are in R")
	
Now time for some prep work! We make each matrix a square and increase it's size to the next power of two. This ensures makes Strassen's Algorithm much easier to manage. We now only need to deal with square matricies that can be broken up an even number of times!

```swift
let n = max(A.rows, A.columns, B.rows, B.columns)
let m = nextPowerOfTwo(after: n)
    
var APrep = Matrix(size: m)
var BPrep = Matrix(size: m)
   
for i in A.rows {
  for j in A.columns {
    APrep[i, j] = A[i,j]
  }
}

for i in B.rows {
  for j in B.columns {
    BPrep[i, j] = B[i, j]
  }
}
```

Finally, we recursively compute the matrix using Strassen's algorithm and the transform our new matrix `C` back to the correct dimensions!

```swift
let CPrep = APrep.strassenR(by: BPrep)
var C = Matrix(rows: A.rows, columns: B.columns)
    
for i in 0..<A.rows {
  for j in 0..<B.columns {
    C[i,j] = CPrep[i,j]
  }
}
```

#### Recursively Computing the Matrix Multiplication

Next let's explore this recursive function `strassenR`.

We start by initializing 8 submatricies.

```swift
var a = Matrix(size: nBy2)
var b = Matrix(size: nBy2)
var c = Matrix(size: nBy2)
var d = Matrix(size: nBy2)
var e = Matrix(size: nBy2)
var f = Matrix(size: nBy2)
var g = Matrix(size: nBy2)
var h = Matrix(size: nBy2)
    
for i in 0..<nBy2 {
  for j in 0..<nBy2 {
    a[i,j] = A[i,j]
    b[i,j] = A[i, j+nBy2]
    c[i,j] = A[i+nBy2, j]
    d[i,j] = A[i+nBy2, j+nBy2]
    e[i,j] = B[i,j]
    f[i,j] = B[i, j+nBy2]
    g[i,j] = B[i+nBy2, j]
    h[i,j] = B[i+nBy2, j+nBy2]
  }
}
```

We next recursively compute the 7 matrix multiplications.

```swift
let p1 = a.strassenR(by: f-h)       // a * (f - h)
let p2 = (a+b).strassenR(by: h)     // (a + b) * h
let p3 = (c+d).strassenR(by: e)     // (c + d) * e
let p4 = d.strassenR(by: g-e)       // d * (g - e)
let p5 = (a+d).strassenR(by: e+h)   // (a + d) * (e + h)
let p6 = (b-d).strassenR(by: g+h)   // (b - d) * (g + h)
let p7 = (a-c).strassenR(by: e+f)   // (a - c) * (e + f)
```

Next, we compute the submatricies of C.

```swift
let c11 = p5 + p4 - p2 + p6         // p5 + p4 - p2 + p6
let c12 = p1 + p2                   // p1 + p2
let c21 = p3 + p4                   // p3 + p4
let c22 = p1 + p5 - p3 - p7         // p1 + p5 - p3 - p7
```

And finally, we combine these submatricies into our new matrix C!

```swift
var C = Matrix(size: n)    
for i in 0..<nBy2 {
  for j in 0..<nBy2 {
    C[i, j]           = c11[i,j]
    C[i, j+nBy2]      = c12[i,j]
    C[i+nBy2, j]      = c21[i,j]
    C[i+nBy2, j+nBy2] = c22[i,j]
  }
}
```

As before, we can analyze the time completxity using the [Master Theorem](https://en.wikipedia.org/wiki/Master_theorem). `T(n) = 7T(n/2) +  O(n^2)` which leads to `O(n^log(7))` runtime. This comes out to approxiamtely `O(n^2.8074)` which is better than `O(n^3)`!

And that's Strassen's algorithm! Here's the full implementation:

```swift
// MARK: - Strassen Multiplication

extension Matrix {
  public func strassenMatrixMultiply(by B: Matrix<T>) -> Matrix<T> {
    let A = self
    assert(A.columns == B.rows, "Two matricies can only be matrix mulitiplied if one has dimensions mxn & the other has dimensions nxp where m, n, p are in R")
    
    let n = max(A.rows, A.columns, B.rows, B.columns)
    let m = nextPowerOfTwo(after: n)
    
    var APrep = Matrix(size: m)
    var BPrep = Matrix(size: m)
    
    A.forEach { (i, j) in
      APrep[i,j] = A[i,j]
    }
    
    B.forEach { (i, j) in
      BPrep[i,j] = B[i,j]
    }
    
    let CPrep = APrep.strassenR(by: BPrep)
    var C = Matrix(rows: A.rows, columns: B.columns)
    for i in 0..<A.rows {
      for j in 0..<B.columns {
        C[i,j] = CPrep[i,j]
      }
    }
    
    return C
  }
  
  private func strassenR(by B: Matrix<T>) -> Matrix<T> {
    let A = self
    assert(A.isSquare && B.isSquare, "This function requires square matricies!")
    guard A.rows > 1 && B.rows > 1 else { return A * B }
    
    let n    = A.rows
    let nBy2 = n / 2
    
    /*
    Assume submatricies are allocated as follows
    
     matrix A = |a b|,    matrix B = |e f|
                |c d|                |g h|
    */
    
    var a = Matrix(size: nBy2)
    var b = Matrix(size: nBy2)
    var c = Matrix(size: nBy2)
    var d = Matrix(size: nBy2)
    var e = Matrix(size: nBy2)
    var f = Matrix(size: nBy2)
    var g = Matrix(size: nBy2)
    var h = Matrix(size: nBy2)
    
    for i in 0..<nBy2 {
      for j in 0..<nBy2 {
        a[i,j] = A[i,j]
        b[i,j] = A[i, j+nBy2]
        c[i,j] = A[i+nBy2, j]
        d[i,j] = A[i+nBy2, j+nBy2]
        e[i,j] = B[i,j]
        f[i,j] = B[i, j+nBy2]
        g[i,j] = B[i+nBy2, j]
        h[i,j] = B[i+nBy2, j+nBy2]
      }
    }
    
    let p1 = a.strassenR(by: f-h)       // a * (f - h)
    let p2 = (a+b).strassenR(by: h)     // (a + b) * h
    let p3 = (c+d).strassenR(by: e)     // (c + d) * e
    let p4 = d.strassenR(by: g-e)       // d * (g - e)
    let p5 = (a+d).strassenR(by: e+h)   // (a + d) * (e + h)
    let p6 = (b-d).strassenR(by: g+h)   // (b - d) * (g + h)
    let p7 = (a-c).strassenR(by: e+f)   // (a - c) * (e + f)
    
    let c11 = p5 + p4 - p2 + p6         // p5 + p4 - p2 + p6
    let c12 = p1 + p2                   // p1 + p2
    let c21 = p3 + p4                   // p3 + p4
    let c22 = p1 + p5 - p3 - p7         // p1 + p5 - p3 - p7
    
    var C = Matrix(size: n)
    for i in 0..<nBy2 {
      for j in 0..<nBy2 {
        C[i, j]           = c11[i,j]
        C[i, j+nBy2]      = c12[i,j]
        C[i+nBy2, j]      = c21[i,j]
        C[i+nBy2, j+nBy2] = c22[i,j]
      }
    }
    
    return C
  }
  
  private func nextPowerOfTwo(after n: Int) -> Int {
    return Int(pow(2, ceil(log2(Double(n)))))
  }
}
```

## Appendix

### Number Protocol

I use a number protocol to enable by Matrix to be generic. 

The Number protocol ensures three things:

1. Everything that is a number can be multiplied
2. Everything that is a number can be added/subtracted
3. Everything that is a number has a zero value

Extending `Int`, `Float`, and `Double` to conform to this protocol is now very straightforward. All you need to do is implement the `static var zero`! 

```swift
public protocol Number: Multipliable, Addable {
  static var zero: Self { get }
}

public protocol Addable {
  static func +(lhs: Self, rhs: Self) -> Self
  static func -(lhs: Self, rhs: Self) -> Self
}

public protocol Multipliable {
  static func *(lhs: Self, rhs: Self) -> Self
}
```

### Dot Product

I extend `Array` to include a dot product function for when the Array's element conform to the `Number` protocol.

```swift
extension Array where Element: Number {
  public func dot(_ b: Array<Element>) -> Element {
    let a = self
    assert(a.count == b.count, "Can only take the dot product of arrays of the same length!")
    let c = a.indices.map{ a[$0] * b[$0] }
    return c.reduce(Element.zero, { $0 + $1 })
  }
}
```

## Resources

+ [Intro to Matrix Multiplication | Khan Academy](https://www.khanacademy.org/math/precalculus/precalc-matrices/multiplying-matrices-by-matrices/v/matrix-multiplication-intro)
+ [Matrix Multiplication | Wikipedia](https://en.wikipedia.org/wiki/Matrix_multiplication)
+ [Strassen Algorithm | Wikipedia](https://en.wikipedia.org/wiki/Strassen_algorithm)
+ [Strassen Algorithm | Wolfram MathWorld](http://mathworld.wolfram.com/StrassenFormulas.html)
+ [Strassens Algorithm | Geeks for Geeks](http://www.geeksforgeeks.org/strassens-matrix-multiplication/)

*Written for Swift Algorithm Club by Richard Ash*