//
//  Matrix.swift
//  
//
//  Created by Richard Ash on 10/28/16.
//
//

import Foundation

enum RowOrColumn {
  case row, column
}

struct Matrix<T: Number> {
  
  // MARK: - Variables
  
  let rows: Int, columns: Int
  var grid: [T]
  
  var isSquare: Bool {
    return rows == columns
  }
  
  var size: MatrixSize {
    return MatrixSize(rows: rows, columns: columns)
  }
  
  // MARK: - Init
  
  init(rows: Int, columns: Int, initialValue: T = T.zero) {
    self.rows = rows
    self.columns = columns
    self.grid = Array(repeating: initialValue, count: rows * columns)
  }
  
  init(size: Int, initialValue: T = T.zero) {
    self.rows = size
    self.columns = size
    self.grid = Array(repeating: initialValue, count: rows * columns)
  }
  
  // MARK: - Subscript
  
  subscript(row: Int, column: Int) -> T {
    get {
      assert(indexIsValid(row: row, column: column), "Index out of range")
      return grid[(row * columns) + column]
    }
    set {
      assert(indexIsValid(row: row, column: column), "Index out of range")
      grid[(row * columns) + column] = newValue
    }
  }
  
  subscript(type: RowOrColumn, value: Int) -> [T] {
    get {
      switch type {
      case .row:
        assert(indexIsValid(row: value, column: 0), "Index out of range")
        return Array(grid[(value * columns)..<(value * columns) + columns])
      case .column:
        assert(indexIsValid(row: 0, column: value), "Index out of range")
        var columns: [T] = []
        for row in 0..<rows {
          for column in 0..<self.columns {
            if column == value {
              columns.append(grid[(row * self.columns) + value])
            }
          }
        }
        return columns
      }
    } set {
      switch type {
      case .row:
        assert(newValue.count == columns)
        for (column, element) in newValue.enumerated() {
          grid[(value * columns) + column] = element
        }
      case .column:
        assert(newValue.count == rows)
        for (row, element) in newValue.enumerated() {
          grid[(row * columns) + value] = element
        }
      }
    }
  }
  
  // MARK: - Private Functions
  
  private func indexIsValid(row: Int, column: Int) -> Bool {
    return row >= 0 && row < rows && column >= 0 && column < columns
  }
  
  private func strassenR(by B: Matrix<T>) -> Matrix<T> {
    let A = self
    assert(A.isSquare && B.isSquare, "This function requires square matricies!")
    guard A.rows > 1 && B.rows > 1 else { return A * B }
    
    let n    = A.rows
    let nBy2 = n / 2
    
    var a11 = Matrix(size: nBy2)
    var a12 = Matrix(size: nBy2)
    var a21 = Matrix(size: nBy2)
    var a22 = Matrix(size: nBy2)
    var b11 = Matrix(size: nBy2)
    var b12 = Matrix(size: nBy2)
    var b21 = Matrix(size: nBy2)
    var b22 = Matrix(size: nBy2)
    
    for i in 0..<nBy2 {
      for j in 0..<nBy2 {
        a11[i,j] = A[i,j]
        a12[i,j] = A[i, j+nBy2]
        a21[i,j] = A[i+nBy2, j]
        a22[i,j] = A[i+nBy2, j+nBy2]
        b11[i,j] = B[i,j]
        b12[i,j] = B[i, j+nBy2]
        b21[i,j] = B[i+nBy2, j]
        b22[i,j] = B[i+nBy2, j+nBy2]
      }
    }
    
    let q1 = (a11+a22).strassenR(by: b11+b22)    // (a11+a22)(b11+b22)
    let q2 = (a21+a22).strassenR(by: b11)        // (a21+a22)b11
    let q3 = a11.strassenR(by: b12-b22)          // a11(b12-b22)
    let q4 = a22.strassenR(by: b21-b11)          // a22(-b11+b21)
    let q5 = (a11+a12).strassenR(by: b22)        // (a11+a22)b22
    let q6 = (a21-a11).strassenR(by: b11+b12)    // (-a11+a21)(b11+b12)
    let q7 = (a12-a22).strassenR(by: b21+b22)    // (a12-a22)(b21+b22)
    
    let c11 = q1 + q4 - q5 + q7
    let c12 = q3 + q5
    let c21 = q2 + q4
    let c22 = q1 + q3 - q2 + q6
    var C   = Matrix(size: n)
    
    for i in 0..<nBy2 {
      for j in 0..<nBy2 {
        C[i, j]           = c11[i,j]
        C[i, j+nBy2]      = c12[i,j]
        C[i+nBy2, j]      = c21[i,j]
        C[i+nBy2, j+nBy2] = c22[i,j]
      }
    }
    
    return C
  }
  
  private func nextPowerOfTwo(of n: Int) -> Int {
    return Int(pow(2, ceil(log2(Double(n)))))
  }
  
  // MARK: - Functions
  
  func strassenMatrixMultiply(by B: Matrix<T>) -> Matrix<T> {
    let A = self
    assert(A.columns == B.rows, "Two matricies can only be matrix mulitiplied if one has dimensions mxn & the other has dimensions nxp where m, n, p are in R")
    
    let n = max(A.rows, A.columns, B.rows, B.columns)
    let m = nextPowerOfTwo(of: n)
    
    var APrep = Matrix(size: m)
    var BPrep = Matrix(size: m)
    
    A.size.forEach { (i, j) in
      APrep[i,j] = A[i,j]
    }
    
    B.size.forEach { (i, j) in
      BPrep[i,j] = B[i,j]
    }
    
    let CPrep = APrep.strassenR(by: BPrep)
    var C = Matrix(rows: A.rows, columns: B.columns)
    
    for i in 0..<A.rows {
      for j in 0..<B.columns {
        C[i,j] = CPrep[i,j]
      }
    }
    return C
  }
  
  func matrixMultiply(by B: Matrix<T>) -> Matrix<T> {
    let A = self
    assert(A.columns == B.rows, "Two matricies can only be matrix mulitiplied if one has dimensions mxn & the other has dimensions nxp where m, n, p are in R")
    
    var C = Matrix<T>(rows: A.rows, columns: B.columns)
    
    for i in 0..<A.rows {
      for j in 0..<B.columns {
        C[i, j] = A[.row, i].dot(B[.column, j])
      }
    }
    
    return C
  }
}

// Term-by-term Matrix Math

func *<T: Number>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
  assert(lhs.size == rhs.size, "To term-by-term multiply matricies they need to be the same size!")
  let rows = lhs.rows
  let columns = lhs.columns
  
  var newMatrix = Matrix<T>(rows: rows, columns: columns)
  for row in 0..<rows {
    for column in 0..<columns {
      newMatrix[row, column] = lhs[row, column] * rhs[row, column]
    }
  }
  return newMatrix
}

func +<T: Number>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
  assert(lhs.size == rhs.size, "To term-by-term add matricies they need to be the same size!")
  let rows = lhs.rows
  let columns = lhs.columns
  
  var newMatrix = Matrix<T>(rows: rows, columns: columns)
  for row in 0..<rows {
    for column in 0..<columns {
      newMatrix[row, column] = lhs[row, column] + rhs[row, column]
    }
  }
  return newMatrix
}

func -<T: Number>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
  assert(lhs.size == rhs.size, "To term-by-term subtract matricies they need to be the same size!")
  let rows = lhs.rows
  let columns = lhs.columns
  
  var newMatrix = Matrix<T>(rows: rows, columns: columns)
  for row in 0..<rows {
    for column in 0..<columns {
      newMatrix[row, column] = lhs[row, column] - rhs[row, column]
    }
  }
  return newMatrix
}
