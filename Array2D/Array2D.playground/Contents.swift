/*
 Two-dimensional array with a fixed number of rows and columns.
 This is mostly handy for games that are played on a grid, such as chess.
 Performance is always O(1).
 */
public struct Array2D<T> {
  public let columns: Int
  public let rows: Int
  fileprivate var array: [T]

  public init(columns: Int, rows: Int, initialValue: T) {
    self.columns = columns
    self.rows = rows
    array = .init(repeating: initialValue, count: rows*columns)
  }

  public subscript(column: Int, row: Int) -> T {
    get {
      precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      return array[row*columns + column]
    }
    set {
      precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      array[row*columns + column] = newValue
    }
  }
}

// initialization
var matrix = Array2D(columns: 3, rows: 5, initialValue: 0)

// makes an array of rows * columns elements all filled with zero
print(matrix.array)

// setting numbers using subscript [x, y]
matrix[0, 0] = 1
matrix[1, 0] = 2

matrix[0, 1] = 3
matrix[1, 1] = 4

matrix[0, 2] = 5
matrix[1, 2] = 6

matrix[0, 3] = 7
matrix[1, 3] = 8
matrix[2, 3] = 9

// now the numbers are set in the array
print(matrix.array)

// print out the 2D array with a reference around the grid
for i in 0..<matrix.rows {
  print("[", terminator: "")
  for j in 0..<matrix.columns {
    if j == matrix.columns - 1 {
      print("\(matrix[j, i])", terminator: "")
    } else {
      print("\(matrix[j, i]) ", terminator: "")
    }
  }
  print("]")
}
