import Foundation

struct Vector: CustomStringConvertible, Equatable {
  private(set) var length = 0
  private(set) var data: [Double]

  init(_ data: [Double]) {
    self.data = data
    self.length = data.count
  }

  var description: String {
    return "Vector (\(data)"
  }

  func distanceTo(other: Vector) -> Double {
    var result = 0.0
    for idx in 0..<length {
      result += pow(data[idx] - other.data[idx], 2.0)
    }
    return sqrt(result)
  }
}

func == (left: Vector, right: Vector) -> Bool {
  for idx in 0..<left.length {
    if left.data[idx] != right.data[idx] {
      return false
    }
  }
  return true
}

func + (left: Vector, right: Vector) -> Vector {
  var results = [Double]()
  for idx in 0..<left.length {
    results.append(left.data[idx] + right.data[idx])
  }
  return Vector(results)
}

func += (inout left: Vector, right: Vector) {
  left = left + right
}

func - (left: Vector, right: Vector) -> Vector {
  var results = [Double]()
  for idx in 0..<left.length {
    results.append(left.data[idx] - right.data[idx])
  }
  return Vector(results)
}

func -= (inout left: Vector, right: Vector) {
  left = left - right
}

func / (left: Vector, right: Double) -> Vector {
  var results = [Double](count: left.length, repeatedValue: 0)
  for (idx, value) in left.data.enumerate() {
    results[idx] = value / right
  }
  return Vector(results)
}

func /= (inout left: Vector, right: Double) {
  left = left / right
}
