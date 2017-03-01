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
      return array[row*columns + column]
    }
    set {
      precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
        
      array[row*columns + column] = newValue
    }
  }
}
