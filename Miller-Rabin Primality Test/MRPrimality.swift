//
//  MRPrimality.swift
//  
//
//  Created by Sahn Cha on 2016. 10. 18..
//
//

import Foundation

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
    var x = modpow64(r, d, n)
    if x == 1 || x == n - 1 { continue }
    
    for _ in 1 ... s - 1 {
      x = modpow64(x, 2, n)
      if x == 1 { return false }
      if x == n - 1 { break }
    }
    
    if x != n - 1 { return false }
  }
  return true
}

private func modpow64(_ base: UInt64, _ exp: UInt64, _ m: UInt64) -> UInt64 {
  if m == 1 { return 0 }
  
  var result: UInt64 = 1
  var b = base % m
  var e = exp
  
  while e > 0 {
    if e % 2 == 1 {
      result = (result * b) % m
    }
    e >>= 1
    b = (b * b) % m
  }
  return result
}
