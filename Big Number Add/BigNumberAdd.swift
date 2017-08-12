//
//  BigNumberAdd.swift
//  
//
//  Created by Kai Chen on 8/12/17.
//
//

import Foundation

public class BigNumber {
  public init() {}
  
  public func add(_ a: String, _ b: String) -> String {
    let size = max(a.characters.count, b.characters.count)
    
    let aZero = paddingZero(size - a.characters.count)
    let aN = aZero + a
    
    let bZero = paddingZero(size - b.characters.count)
    let bN = bZero + b
    
    var ret = ""
    var flag = 0
    for i in (0..<size).reversed() {
      let aIndex = aN.index(aN.startIndex, offsetBy: i)
      let bIndex = bN.index(bN.startIndex, offsetBy: i)
      
      var digit =
        (Int)(aN[aIndex].asciiValue - Character("0").asciiValue) +
          (Int)(bN[bIndex].asciiValue - Character("0").asciiValue) +
      flag
      
      flag = digit / 10
      digit = digit % 10
      
      ret = String(UnicodeScalar(UInt8(digit + (Int)(Character("0").asciiValue)))) + ret
    }
    
    if flag > 0 {
      ret = String(UnicodeScalar(UInt8(flag + (Int)(Character("0").asciiValue)))) + ret
    }
    
    return ret
  }
  
  private func paddingZero(_ size: Int) -> String {
    var zero = ""
    for _ in 0..<size {
      zero += "0"
    }
    
    return zero
  }
}

extension Character {
  var asciiValue: UInt32 {
    return String(self).unicodeScalars.filter{$0.isASCII}.first!.value
  }
}
