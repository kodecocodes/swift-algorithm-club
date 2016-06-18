//: Playground - noun: a place where people can play

func twoSumProblem(a: [Int], k: Int) -> ((Int, Int))? {
  var map = [Int: Int]()

  for i in 0 ..< a.count {
    if let newK = map[a[i]] {
      return (newK, i)
    } else {
      map[k - a[i]] =  i
    }
  }
  return nil
}

let a = [7, 100, 2, 21, 12, 10, 22, 14, 3, 4, 8, 4, 9]
if let (i, j) = twoSumProblem(a, k: 33) {
  i            // 3
  a[i]         // 21
  j            // 4
  a[j]         // 12
  a[i] + a[j]  // 33
}

twoSumProblem(a, k: 37)  // nil
