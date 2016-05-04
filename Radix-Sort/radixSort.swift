func radixSort(inout arr: [Int] ) {

  let radix = 10
  var done = false
  var index: Int
  var digit = 1

  while !done {
    done = true

    var buckets: [[Int]] = []

    for _ in 1...radix {
      buckets.append([])
    }


    for number in arr  {
      index = number / digit
      buckets[index % radix].append(number)
      if done && index > 0 {
        done = false
      }
    }

    var i = 0

    for j in 0..<radix {
      let bucket = buckets[j]
      for number in bucket {
        arr[i] = number
        i += 1
      }
    }

    digit *= radix
  }
}

var a: [Int] = [0, 69, 28, 14, 32, 1, 1, 1111, 1111111, 55, 123, 236626456256, 9393, 23, 66]
radixSort(&a)
print(a)
