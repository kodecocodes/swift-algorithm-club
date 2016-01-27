/*
  Two-dimensional array with a fixed number of rows and columns.
  This is mostly handy for games that are played on a grid, such as chess.
  Performance is always O(1).
*/
public struct Array2D<T> {
  public let columns: Int
  public let rows: Int
  private var array: [T]

  public init(columns: Int, rows: Int, initialValue: T) {
    self.columns = columns
    self.rows = rows
    array = .init(count: rows*columns, repeatedValue: initialValue)
  }

  public subscript(column: Int, row: Int) -> T {
    get {
      return array[row*columns + column]
    }
    set {
      array[row*columns + column] = newValue
    }
  }
}
