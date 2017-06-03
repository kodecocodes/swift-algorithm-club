//
//  Matrix.swift
//  
//
//  Created by Richard Ash on 10/28/16.
//
//

import Foundation

public struct Matrix<T: Number> {

  // MARK: - Martix Objects

  public enum Index {
    case row, column
  }

  public struct Size: Equatable {
    let rows: Int, columns: Int

    public static func == (lhs: Size, rhs: Size) -> Bool {
      return lhs.columns == rhs.columns && lhs.rows == rhs.rows
    }
  }

  // MARK: - Variables

  let rows: Int, columns: Int
  let size: Size

  var grid: [T]

  var isSquare: Bool {
    return rows == columns
  }

  // MARK: - Init

  public init(rows: Int, columns: Int, initialValue: T = T.zero) {
    self.rows = rows
    self.columns = columns
    self.size = Size(rows: rows, columns: columns)
    self.grid = Array(repeating: initialValue, count: rows * columns)
  }

  public init(size: Int, initialValue: T = T.zero) {
    self.init(rows: size, columns: size, initialValue: initialValue)
  }

  // MARK: - Private Functions

  fileprivate func indexIsValid(row: Int, column: Int) -> Bool {
    return row >= 0 && row < rows && column >= 0 && column < columns
  }

  // MARK: - Subscript

  public subscript(row: Int, column: Int) -> T {
    get {
      assert(indexIsValid(row: row, column: column), "Index out of range")
      return grid[(row * columns) + column]
    } set {
      assert(indexIsValid(row: row, column: column), "Index out of range")
      grid[(row * columns) + column] = newValue
    }
  }

  public subscript(type: Matrix.Index, value: Int) -> [T] {
    get {
      switch type {
      case .row:
        assert(indexIsValid(row: value, column: 0), "Index out of range")
        return Array(grid[(value * columns)..<(value * columns) + columns])
      case .column:
        assert(indexIsValid(row: 0, column: value), "Index out of range")
        let column = (0..<rows).map { (currentRow) -> T in
          let currentColumnIndex = currentRow * columns + value
          return grid[currentColumnIndex]
        }
        return column
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

  // MARK: - Public Functions

  public func row(for columnIndex: Int) -> [T] {
    assert(indexIsValid(row: columnIndex, column: 0), "Index out of range")
    return Array(grid[(columnIndex * columns)..<(columnIndex * columns) + columns])
  }

  public func column(for rowIndex: Int) -> [T] {
    assert(indexIsValid(row: 0, column: rowIndex), "Index out of range")

    let column = (0..<rows).map { (currentRow) -> T in
      let currentColumnIndex = currentRow * columns + rowIndex
      return grid[currentColumnIndex]
    }
    return column
  }

  public func forEach(_ body: (Int, Int) throws -> Void) rethrows {
    for row in 0..<rows {
      for column in 0..<columns {
        try body(row, column)
      }
    }
  }
}

// MARK: - Matrix Multiplication Function

extension Matrix {
  public func matrixMultiply(by B: Matrix<T>) -> Matrix<T> {
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

// MARK: - Strassen Multiplication

extension Matrix {
  public func strassenMatrixMultiply(by B: Matrix<T>) -> Matrix<T> {
    let A = self
    assert(A.columns == B.rows, "Two matricies can only be matrix mulitiplied if one has dimensions mxn & the other has dimensions nxp where m, n, p are in R")

    let n = max(A.rows, A.columns, B.rows, B.columns)
    let m = nextPowerOfTwo(after: n)

    var APrep = Matrix(size: m)
    var BPrep = Matrix(size: m)

    A.forEach { (i, j) in
      APrep[i, j] = A[i, j]
    }

    B.forEach { (i, j) in
      BPrep[i, j] = B[i, j]
    }

    let CPrep = APrep.strassenR(by: BPrep)
    var C = Matrix(rows: A.rows, columns: B.columns)
    for i in 0..<A.rows {
      for j in 0..<B.columns {
        C[i, j] = CPrep[i, j]
      }
    }

    return C
  }

  private func strassenR(by B: Matrix<T>) -> Matrix<T> {
    let A = self
    assert(A.isSquare && B.isSquare, "This function requires square matricies!")
    guard A.rows > 1 && B.rows > 1 else { return A * B }

    let n    = A.rows
    let nBy2 = n / 2

    /*
    Assume submatricies are allocated as follows
    
     matrix A = |a b|,    matrix B = |e f|
                |c d|                |g h|
    */

    var a = Matrix(size: nBy2)
    var b = Matrix(size: nBy2)
    var c = Matrix(size: nBy2)
    var d = Matrix(size: nBy2)
    var e = Matrix(size: nBy2)
    var f = Matrix(size: nBy2)
    var g = Matrix(size: nBy2)
    var h = Matrix(size: nBy2)

    for i in 0..<nBy2 {
      for j in 0..<nBy2 {
        a[i, j] = A[i, j]
        b[i, j] = A[i, j+nBy2]
        c[i, j] = A[i+nBy2, j]
        d[i, j] = A[i+nBy2, j+nBy2]
        e[i, j] = B[i, j]
        f[i, j] = B[i, j+nBy2]
        g[i, j] = B[i+nBy2, j]
        h[i, j] = B[i+nBy2, j+nBy2]
      }
    }

    let p1 = a.strassenR(by: f-h)       // a * (f - h)
    let p2 = (a+b).strassenR(by: h)     // (a + b) * h
    let p3 = (c+d).strassenR(by: e)     // (c + d) * e
    let p4 = d.strassenR(by: g-e)       // d * (g - e)
    let p5 = (a+d).strassenR(by: e+h)   // (a + d) * (e + h)
    let p6 = (b-d).strassenR(by: g+h)   // (b - d) * (g + h)
    let p7 = (a-c).strassenR(by: e+f)   // (a - c) * (e + f)

    let c11 = p5 + p4 - p2 + p6         // p5 + p4 - p2 + p6
    let c12 = p1 + p2                   // p1 + p2
    let c21 = p3 + p4                   // p3 + p4
    let c22 = p1 + p5 - p3 - p7         // p1 + p5 - p3 - p7

    var C = Matrix(size: n)
    for i in 0..<nBy2 {
      for j in 0..<nBy2 {
        C[i, j]           = c11[i, j]
        C[i, j+nBy2]      = c12[i, j]
        C[i+nBy2, j]      = c21[i, j]
        C[i+nBy2, j+nBy2] = c22[i, j]
      }
    }

    return C
  }

  private func nextPowerOfTwo(after n: Int) -> Int {
    return Int(pow(2, ceil(log2(Double(n)))))
  }
}

// Term-by-term Matrix Math

extension Matrix: Addable {
  public static func +<T: Number>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
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

  public static func -<T: Number>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
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
}

extension Matrix: Multipliable {
  public static func *<T: Number>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
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
}
