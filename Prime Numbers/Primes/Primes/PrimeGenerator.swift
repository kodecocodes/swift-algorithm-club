//
//  Operators.swift
//  Primes
//
//  Created by Pratikbhai Patel on 6/13/16.
//  Copyright © 2016 Pratikbhai Patel. All rights reserved.
//

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
    return [T](stride(from: left.0, through: right, by: left.1))
}

class PrimeGenerator {
    
    static let sharedInstance = PrimeGenerator()
    
    
    
    
    func eratosthenesPrimes(_ max: Int, completion:([Int]) -> ()){
        let m = Int(sqrt(ceil(Double(max))))
        let set = NSMutableSet(array: 3..2..max)
        set.add(2)
        for i in (2..1..m) {
            if (set.contains(i)) {
                for j in i^^2..i..max {
                    set.remove(j)
                }
            }
        }
        completion(set.sortedArray(using: [SortDescriptor(key: "integerValue", ascending: true)]) as! [Int])
    }
    
    func atkinsPrimes(_ max: Int, completion:([Int]) -> ()) {
        var is_prime = [Bool](repeating: false, count: max + 1)
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
        for (idx, val) in is_prime.enumerated() {
            if val == true { primesArray.append(idx) }
        }
        completion(primesArray)
    }
    
}
