# Sieve Primes

## Sieve of Eratosthenes
Goal: To quickly get an array of prime numbers with a specified limit using the Sieve of Eratosthenes.

The Sieve of Eratosthenes is an algorithm that finds all primes numbers up to any given limit by iteratively marking composites of each prime starting with multiples of 2. [Seeing this algorithm][1] in action is the best way to understand it.


### Implementation

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

## Sieve of Atkin

Goal: To quickly get an array of prime numbers with a specified limit using the Sieve of Atkin.

The Sieve of Atkin is an algorithm that finds all primes numbers up to any given limit.

--*write some introduction to the Sieve of Atkin*--

### Implementation

```
func primesTo(max: Int) -> [Int] {
    var is_prime = [Bool](count: max + 1, repeatedValue: false)
    is_prime[2] = true
    is_prime[3] = true
    let limit = Int(ceil(sqrt(Double(max))))
    for x in 1...limit {
        for y in 1...limit {
            var num = 4 * x * x + y * y
            if (num <= max && (num % 12 == 1 || num % 12 == 5)) {
                is_prime[num] = true
            }
            num = 3 * x * x + y * y
            if (num <= max && num % 12 == 7) {
                is_prime[num] = true
            }
            if (x > y) {
                num = 3 * x * x - y * y
                if (num <= max && num % 12 == 11) {
                    is_prime[num] = true
                }
            }
        }
    }
    if limit > 5 {
        for i in 5...limit {
            if is_prime[i] {
                for j in (i * i)..i..max {
                    is_prime[j] = false
                }
            }
        }
    }
    var primesArray = [Int]()
    for (idx, val) in is_prime.enumerate() {
        if val == true { primesArray.append(idx) }
    }
    return primesArray
}
```
Put this code in a playground and test it like so:

```
let primesArray = primesTo(50)
print(primesArray)
// prints [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
```

## See also


[1]:https://en.wikipedia.org/wiki/File:Sieve_of_Eratosthenes_animation.gif#/media/File:Sieve_of_Eratosthenes_animation.gif

[Sieve of Eratosthenes on Wikipedia](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes)

[Sieve of Atkin on Wikipedia](https://en.wikipedia.org/wiki/Sieve_of_Atkin)

*Written for Swift Algorithm Club by Pratikbhai Patel*