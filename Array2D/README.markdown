# Array2D

In C and Objective-C, you can write the following line,

	int cookies[9][7];
	
to make a 9x7 grid of cookies. This creates a two-dimensional array of 63 elements. To find the cookie at column 3 and row 6, you can write:

	myCookie = cookies[3][6];
	
This statement is not acceptable in Swift. To create a multi-dimensional array in Swift, you can write:

```swift
var cookies = [[Int]]()
for _ in 1...9 {
  var row = [Int]()
  for _ in 1...7 {
    row.append(0)
  }
  cookies.append(row)
}
```

Then, to find a cookie, you can write:

```swift
let myCookie = cookies[3][6]
```

You can also create the array in a single line of code:

```swift
var cookies = [[Int]](repeating: [Int](repeating: 0, count: 7), count: 9)
```

This looks complicated, but you can simplify it with a helper function:

```swift
func dim<T>(_ count: Int, _ value: T) -> [T] {
  return [T](repeating: value, count: count)
}
```

Then, you can create the array:

```swift
var cookies = dim(9, dim(7, 0))
```

Swift infers that the datatype of the array must be `Int` because you specified `0` as the default value of the array elements. To use a string instead, you can write:

```swift
var cookies = dim(9, dim(7, "yum"))
```

The `dim()` function makes it easy to go into even more dimensions:

```swift
var threeDimensions = dim(2, dim(3, dim(4, 0)))
```

The downside of using multi-dimensional arrays or multiple nested arrays in this way is to lose track of what dimension represents what.

Instead, you can create your own type that acts like a 2-D array which is more convenient to use:

```swift
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
```

`Array2D` is a generic type, so it can hold any kind of object, not just numbers.

To create an instance of `Array2D`, you can write:

```swift
var cookies = Array2D(columns: 9, rows: 7, initialValue: 0)
```

By using the `subscript` function, you can retrieve an object from the array:

```swift
let myCookie = cookies[column, row]
```

Or, you can change it:

```swift
cookies[column, row] = newCookie
```

Internally, `Array2D` uses a single one-dimensional array to store the data. The index of an object in that array is given by `(row x numberOfColumns) + column`, but as a user of `Array2D`, you only need to think in terms of "column" and "row", and the details will be done by `Array2D`. This is the advantage of wrapping primitive types into a wrapper class or struct.

*Written for Swift Algorithm Club by Matthijs Hollemans*
