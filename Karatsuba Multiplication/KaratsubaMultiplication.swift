//
//  KaratsubaMultiplication.swift
//  
//
//  Created by Richard Ash on 9/12/16.
//
//

import Foundation

func karatsuba(num1: Int, _ num2: Int) -> Int {
  let num1Array = String(num1).characters
  let num2Array = String(num2).characters
  
  guard num1Array.count > 1 && num2Array.count > 1 else {
    return num1 * num2
  }
  
  let n = max(num1Array.count, num2Array.count)
  let nBy2 = n / 2
  
  let a = num1 / 10^^nBy2
  let b = num1 % 10^^nBy2
  let c = num2 / 10^^nBy2
  let d = num2 % 10^^nBy2
  
  let ac = karatsuba(a, c)
  let bd = karatsuba(b, d)
  let adPluscd = karatsuba(a+b, c+d) - ac - bd
  
  let product = ac * 10^^(2 * nBy2) + adPluscd * 10^^nBy2 + bd
  
  return product
}