//
//  main.swift
//  Introsort
//
//  Created by Richard Ash on 7/18/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Foundation

extension Array {
  static func random(size: Int, upperBound: Int = 1000) -> [Int] {
    return (0..<size).map{ _ in Int(arc4random_uniform(UInt32(upperBound))) }
  }
}
