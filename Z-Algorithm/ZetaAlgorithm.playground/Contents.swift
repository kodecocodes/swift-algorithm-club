//: Playground - noun: a place where people can play

func ZetaAlgorithm(ptrn: String) -> [Int]? {
  let pattern = Array(ptrn)
  let patternLength = pattern.count

  guard patternLength > 0 else {
    return nil
  }

  var zeta = [Int](repeating: 0, count: patternLength)

  var left = 0
  var right = 0
  var k_1 = 0
  var betaLength = 0
  var textIndex = 0
  var patternIndex = 0

  for k in 1 ..< patternLength {
    if k > right {
      patternIndex = 0

      while k + patternIndex < patternLength  &&
        pattern[k + patternIndex] == pattern[patternIndex] {
          patternIndex = patternIndex + 1
      }

      zeta[k] = patternIndex

      if zeta[k] > 0 {
        left = k
        right = k + zeta[k] - 1
      }
    } else {
      k_1 = k - left + 1
      betaLength = right - k + 1

      if zeta[k_1 - 1] < betaLength {
        zeta[k] = zeta[k_1 - 1]
      } else if zeta[k_1 - 1] >= betaLength {
        textIndex = betaLength
        patternIndex = right + 1

        while patternIndex < patternLength && pattern[textIndex] == pattern[patternIndex] {
          textIndex = textIndex + 1
          patternIndex = patternIndex + 1
        }

        zeta[k] = patternIndex - k
        left = k
        right = patternIndex - 1
      }
    }
  }
  return zeta
}

extension String {

  func indexesOf(pattern: String) -> [Int]? {
    let patternLength = pattern.count
    let zeta = ZetaAlgorithm(ptrn: pattern + "💲" + self)

    guard zeta != nil else {
      return nil
    }

    var indexes: [Int] = []

    /* Scan the zeta array to find matched patterns */
    for i in 0 ..< zeta!.count {
      if zeta![i] == patternLength {
        indexes.append(i - patternLength - 1)
      }
    }

    guard !indexes.isEmpty else {
      return nil
    }

    return indexes
  }
}

/* Examples */

let str = "Hello, playground!"
str.indexesOf(pattern: "ground")   // [11]

let traffic = "🚗🚙🚌🚕🚑🚐🚗🚒🚚🚎🚛🚐🏎🚜🚗🏍🚒🚲🚕🚓🚌🚑"
traffic.indexesOf(pattern: "🚑") // [4, 21]
