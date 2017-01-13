//
//  MatrixSize.swift
//  
//
//  Created by Richard Ash on 10/28/16.
//
//

import Foundation

public struct MatrixSize: Equatable {
  let rows: Int
  let columns: Int
  
  public init(rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns
  }
  
  public func forEach(_ body: (Int, Int) throws -> Void) rethrows {
    for row in 0..<rows {
      for column in 0..<columns {
        try? body(row, column)
      }
    }
  }
}

public extension MatrixSize {
  static func ==(lhs: MatrixSize, rhs: MatrixSize) -> Bool {
    return lhs.columns == rhs.columns && lhs.rows == rhs.rows
  }
}
