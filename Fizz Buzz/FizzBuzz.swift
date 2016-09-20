func fizzBuzz(_ numberOfTurns: Int) {
  for i in 1...numberOfTurns {
    var result = ""

    if i % 3 == 0 {
      result += "Fizz"
    }

    if i % 5 == 0 {
      result += (result.isEmpty ? "" : " ") + "Buzz"
    }

    if result.isEmpty {
      result += "\(i)"
    }

    print(result)
  }
}
