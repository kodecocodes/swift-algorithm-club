//
//  Prime.swift
//
//
//  Created by Kai Chen on 7/28/17.
//
//

import Foundation

public class SlowPrime {
    
    public init() {}
    
    public func findPrimes(_ n: Int) -> [Int] {
        var ret: [Int] = []
        for i in 0...n {
            if isPrime(i) {
                ret.append(i)
            }
        }
        
        return ret
    }
    
    private func isPrime(_ n: Int) -> Bool {
        if n <= 1 {
            return false
        }
        
        for i in 2..<n {
            if n % i == 0 {
                return false
            }
        }
        
        return true
    }
}

public class FastPrime {
    
    public init() {}
    
    public func findPrimes(_ n: Int) -> [Int] {
        var ret: [Int] = []
        for i in 0...n {
            if isPrime(i, primes: &ret) {
                ret.append(i)
            }
        }
        
        return ret
    }
    
    private func isPrime(_ n: Int, primes: inout [Int]) -> Bool {
        if n <= 1 {
            return false
        }
        
        for prime in primes {
            if n % prime == 0 {
                return false
            }
        }
        
        return true
    }
}
