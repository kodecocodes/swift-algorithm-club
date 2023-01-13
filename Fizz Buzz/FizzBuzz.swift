// Last checked with Xcode Version 11.4.1 (11E503a)


/**
*  This function takes in an integer numberOfTurns as an input and prints out the numbers from 1 to numberOfTurns with the following modification:
*  - If the number is divisible by 3, it prints "Fizz" instead of the number
*  - If the number is divisible by 5, it prints "Buzz" instead of the number
*  - If the number is divisible by both 3 and 5, it prints "Fizz Buzz" instead of the number
*  - If the numberOfTurns is less than 1, it will print "Number of turns must be >= 1"
*
*  - parameter numberOfTurns: the number of turns for the fizzbuzz game
*/


func fizzBuzz(_ numberOfTurns: Int) {
    guard numberOfTurns >= 1 else {
        print("Number of turns must be >= 1")
        return
    }
    
    for i in 1...numberOfTurns {
        switch (i.isMultiple(of: 3), i.isMultiple(of: 5)) {
        case (false, false):
            print("\(i)")
        case (true, false):
            print("Fizz")
        case (false, true):
            print("Buzz")
        case (true, true):
            print("Fizz Buzz")
        }
    }
}
