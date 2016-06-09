# Sieve Primes

Goal: To quickly get an array of prime numbers with a specified limit using the Sieve of Eratosthenes.

The Sieve of Eratosthenes is an algorithm that finds all primes numbers up to any given limit.

Here's an implementation in Swift that should be easy to understand:

```
func primesTo(max: Int) -> [Int] {
    let m = Int(sqrt(ceil(Double(max))))
    let set = NSMutableSet(array: 3..2..max)
    set.addObject(2)
    for i in (2..1..m) {
        if (set.containsObject(i)) {
            for j in i^^2..i..max {
                set.removeObject(j)
            }
        }
    }
    return set.sortedArrayUsingDescriptors([NSSortDescriptor(key: "integerValue", ascending: true)]) as! [Int]
}
```

Put this code in a playground and test it like so:

```
let primesArray = primesTo(50)
print(primesArray)
// prints [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
```

--*write some introduction to the Sieve of Eratosthenes*--

## See also

[Sieve of Eratosthenes on Wikipedia](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes)

*Written for Swift Algorithm Club by Pratikbhai Patel*