//
//  MatrixSize.swift
//  
//
//  Created by Richard Ash on 10/28/16.
//
//

import Foundation

struct MatrixSize: Equatable {
  let rows: Int
  let columns: Int
  
  func forEach(_ body: (Int, Int) throws -> Void) rethrows {
    for row in 0..<rows {
      for column in 0..<columns {
        try? body(row, column)
      }
    }
  }
}

func ==(lhs: MatrixSize, rhs: MatrixSize) -> Bool {
  return lhs.columns == rhs.columns && lhs.rows == rhs.rows
}
