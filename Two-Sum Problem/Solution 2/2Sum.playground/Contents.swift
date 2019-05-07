//: Playground - noun: a place where people can play
// Last checked with: Version 10.0 (10A255)

func twoSumProblem(_ a: [Int], k: Int) -> ((Int, Int))? {
  var i = 0
  var j = a.count - 1

  while i < j {
    let sum = a[i] + a[j]
    if sum == k {
      return (i, j)
    } else if sum < k {
      i += 1
    } else {
      j -= 1
    }
  }
  return nil
}

let a = [2, 3, 4, 4, 7, 8, 9, 10, 12, 14, 21, 22, 100]
if let (i, j) = twoSumProblem(a, k: 33) {
  i            // 8
  a[i]         // 12
  j            // 10
  a[j]         // 21
  a[i] + a[j]  // 33
}

twoSumProblem(a, k: 37)  // nil
