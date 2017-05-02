//: Playground - noun: a place where people can play

import Foundation
import UIKit

infix operator ^^ { associativity left precedence 160 }
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(CGFloat(radix), CGFloat(power)))
}

infix operator .. {associativity left precedence 60 }

func ..<T: Strideable>(left: T, right: T.Stride) -> (T, T.Stride) {
    return (left, right)
}

func ..<T: Strideable>(left: (T, T.Stride), right: T) -> [T] {
    return [T](left.0.stride(through: right, by: left.1))
}

func eratosthenes_sieve(max: Int) -> [Int] {
    assert(max > 1, "Prime numbers can only be above 1")
    print("Getting all primes under \(max)")
    let m = Int(sqrt(ceil(Double(max))))
    print("Need to remove all multiples of numbers through \(m)")
    let set = NSMutableSet(array: 3..2..max)
    set.addObject(2)
    print(set)
    for i in (2..1..m) {
        if (set.containsObject(i)) {
            print("Removing all multiples of \(i)")
            for j in i^^2..i..max {
                print("removing j: \(j)")
                set.removeObject(j)
            }
        }
    }
    return set.sortedArrayUsingDescriptors([NSSortDescriptor(key: "integerValue", ascending: true)]) as! [Int]
}

var startDate = NSDate().timeIntervalSince1970 * 1000
print(eratosthenes_sieve(5000))
var endDate = NSDate().timeIntervalSince1970 * 1000
print("Prime generation time: \(endDate - startDate) ms.")

func atkins_sieve(max: Int) -> [Int] {
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

startDate = NSDate().timeIntervalSince1970 * 1000
print(atkins_sieve(5000))
endDate = NSDate().timeIntervalSince1970 * 1000
print("Prime generation time: \(endDate - startDate) ms.")