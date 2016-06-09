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

func primesTo(max: Int) -> [Int] {
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

let startDate = NSDate().timeIntervalSince1970 * 1000
print(primesTo(50))
let endDate = NSDate().timeIntervalSince1970 * 1000
print("Prime generation time: \(endDate - startDate) ms.")