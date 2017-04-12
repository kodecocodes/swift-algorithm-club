//
//  MRPrimality.swift
//  
//
//  Created by Sahn Cha on 2016. 10. 18..
//
//

import Foundation

/*
  Miller-Rabin Primality Test.
  One of the most used algorithms for primality testing.
  Since this is a probabilistic algorithm, it needs to be executed multiple times to increase accuracy.
  
  Inputs:
    n: UInt64 { target integer to be tested for primality }
    k: Int    { optional. number of iterations }
 
  Outputs:
    true      { probably prime }
    false     { composite }
 */
public func mrPrimalityTest(_ n: UInt64, iteration k: Int = 1) -> Bool {
  guard n > 2 && n % 2 == 1 else { return false }
  
  var d = n - 1
  var s = 0
  
  while d % 2 == 0 {
    d /= 2
    s += 1
  }
  
  let range = UInt64.max - UInt64.max % (n - 2)
  var r: UInt64 = 0
  repeat {
    arc4random_buf(&r, MemoryLayout.size(ofValue: r))
  } while r >= range
  
  r = r % (n - 2) + 2
  
  for _ in 1 ... k {
    var x = powmod64(r, d, n)
    if x == 1 || x == n - 1 { continue }
    
    if s == 1 { s = 2 }
    
    for _ in 1 ... s - 1 {
      x = powmod64(x, 2, n)
      if x == 1 { return false }
      if x == n - 1 { break }
    }
    
    if x != n - 1 { return false }
  }
  
  return true
}

/*
  Calculates (base^exp) mod m.
 
  Inputs:
    base: UInt64  { base }
    exp: UInt64   { exponent }
    m: UInt64     { modulus }
 
  Outputs:
    the result
 */
private func powmod64(_ base: UInt64, _ exp: UInt64, _ m: UInt64) -> UInt64 {
  if m == 1 { return 0 }
  
  var result: UInt64 = 1
  var b = base % m
  var e = exp
  
  while e > 0 {
    if e % 2 == 1 { result = mulmod64(result, b, m) }
    b = mulmod64(b, b, m)
    e >>= 1
  }
  
  return result
}

/*
  Calculates (first * second) mod m, hopefully without overflow. :]
 
  Inputs:
    first: UInt64   { first integer }
    second: UInt64  { second integer }
    m: UInt64       { modulus }
 
  Outputs:
    the result
 */
private func mulmod64(_ first: UInt64, _ second: UInt64, _ m: UInt64) -> UInt64 {
  var result: UInt64 = 0
  var a = first
  var b = second
  
  while a != 0 {
    if a % 2 == 1 { result = ((result % m) + (b % m)) % m } // This may overflow if 'm' is a 64bit number && both 'result' and 'b' are very close to but smaller than 'm'.
    a >>= 1
    b = (b << 1) % m
  }
  
  return result
}
