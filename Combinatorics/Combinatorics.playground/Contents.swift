//: Playground - noun: a place where people can play

/* Calculates n! */
func factorial(n: Int) -> Int {
  var n = n
  var result = 1
  while n > 1 {
    result *= n
    n -= 1
  }
  return result
}

factorial(5)
factorial(20)



/*
 Calculates P(n, k), the number of permutations of n distinct symbols
 in groups of size k.
 */
func permutations(n: Int, _ k: Int) -> Int {
  var n = n
  var answer = n
  for _ in 1..<k {
    n -= 1
    answer *= n
  }
  return answer
}

permutations(5, 3)
permutations(50, 6)
permutations(9, 4)



/*
 Prints out all the permutations of the given array.
 Original algorithm by Niklaus Wirth.
 See also Dr.Dobb's Magazine June 1993, Algorithm Alley
 */
func permuteWirth<T>(a: [T], _ n: Int) {
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

let letters = ["a", "b", "c", "d", "e"]
print("Permutations of \(letters):")
permuteWirth(letters, letters.count - 1)

let xyz = [ "x", "y", "z" ]
print("\nPermutations of \(xyz):")
permuteWirth(xyz, 2)



/*
 Prints out all the permutations of an n-element collection.

 The initial array must be initialized with all zeros. The algorithm
 uses 0 as a flag that indicates more work to be done on each level
 of the recursion.

 Original algorithm by Robert Sedgewick.
 See also Dr.Dobb's Magazine June 1993, Algorithm Alley
 */
func permuteSedgewick(a: [Int], _ n: Int, inout _ pos: Int) {
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

print("\nSedgewick permutations:")
let numbers = [0, 0, 0, 0]  // must be all zeros
var pos = -1
permuteSedgewick(numbers, 0, &pos)



/*
 Calculates C(n, k), or "n-choose-k", i.e. how many different selections
 of size k out of a total number of distinct elements (n) you can make.
 */
func combinations(n: Int, _ k: Int) -> Int {
  return permutations(n, k) / factorial(k)
}

combinations(3, 2)
combinations(28, 5)

print("\nCombinations:")
for i in 1...20 {
  print("\(20)-choose-\(i) = \(combinations(20, i))")
}



/*
 Calculates C(n, k), or "n-choose-k", i.e. the number of ways to choose
 k things out of n possibilities.
 */
func quickBinomialCoefficient(n: Int, _ k: Int) -> Int {
  var result = 1

  for i in 0..<k {
    result *= (n - i)
    result /= (i + 1)
  }
  return result
}

quickBinomialCoefficient(8, 2)
quickBinomialCoefficient(30, 15)



/* Supporting code because Swift doesn't have a built-in 2D array. */
struct Array2D<T> {
  let columns: Int
  let rows: Int
  private var array: [T]

  init(columns: Int, rows: Int, initialValue: T) {
    self.columns = columns
    self.rows = rows
    array = .init(count: rows*columns, repeatedValue: initialValue)
  }

  subscript(column: Int, row: Int) -> T {
    get { return array[row*columns + column] }
    set { array[row*columns + column] = newValue }
  }
}

/*
 Calculates C(n, k), or "n-choose-k", i.e. the number of ways to choose
 k things out of n possibilities.

 Thanks to the dynamic programming, this algorithm from Skiena allows for
 the calculation of much larger numbers, at the cost of temporary storage
 space for the cached values.
 */

func binomialCoefficient(n: Int, _ k: Int) -> Int {
  var bc = Array(count: n + 1, repeatedValue: Array(count: n + 1, repeatedValue: 0))

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

binomialCoefficient(30, 15)
binomialCoefficient(66, 33)
