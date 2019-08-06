
import Foundation

/// @param numbers must be an array of sequential numbers, not smaller than 2
func sieve(_ numbers: [UInt]) -> [UInt] {
    if numbers.isEmpty { return [] }
    let p = numbers[0]
    assert(p > 1, "numbers must start at 2 or higher")
    let rest = numbers[1..<numbers.count]
    return [p] + sieve(rest.filter { $0 % p > 0 })
}

func primesUpTo(_ max: UInt) -> [UInt] {
    return [1] + sieve(Array(2...max))
}

print(primesUpTo(100))
