//
//  MatrixSize.swift
//  
//
//  Created by Richard Ash on 10/28/16.
//
//

import Foundation

public struct MatrixSize {
  let rows: Int
  let columns: Int
}

extension MatrixSize: Equatable {
  public static func ==(lhs: MatrixSize, rhs: MatrixSize) -> Bool {
    return lhs.columns == rhs.columns && lhs.rows == rhs.rows
  }
}
