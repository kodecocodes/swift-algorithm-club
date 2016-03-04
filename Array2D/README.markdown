# Array2D

In C and Objective-C you can write the following line,

	int cookies[9][7];
	
to make a 9x7 grid of cookies. This would create a two-dimensional array of 63 elements. To find the cookie at column 3, row 6, you'd write:

	myCookie = cookies[3][6];
	
Unfortunately, you can't write the above in Swift. To create a multi-dimensional array in Swift you'd have to do something like this:

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

And then to find a cookie:

```swift
let myCookie = cookies[3][6]
```

Actually, you could create the array in a single line of code, like so:

```swift
var cookies = [[Int]](count: 9, repeatedValue: [Int](count: 7, repeatedValue: 0))
```

but that's just ugly. To be fair, you can hide the ugliness in a helper function:

```swift
func dim<T>(count: Int, _ value: T) -> [T] {
  return [T](count: count, repeatedValue: value)
}
```

And then creating the array looks like this:

```swift
var cookies = dim(9, dim(7, 0))
```

Swift infers that the datatype of the array should be `Int` because you specified `0` as the default value of the array elements. To use a string instead, you'd write:

```swift
var cookies = dim(9, dim(7, "yum"))
```

The `dim()` function makes it easy to go into even more dimensions:

```swift
var threeDimensions = dim(2, dim(3, dim(4, 0)))
```

The downside of using multi-dimensional arrays in this fashion -- actually, multiple nested arrays -- is that it's easy to lose track of what dimension represents what.

So instead let's create our own type that acts like a 2-D array and that is more convenient to use. Here it is, short and sweet:

```swift
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
```

`Array2D` is a generic type, so it can hold any kind of object, not just numbers.

To create an instance of `Array2D` you'd write:

```swift
var cookies = Array2D(columns: 9, rows: 7, initialValue: 0)
```

Thanks to the `subscript` function, you can do the following to retrieve an object from the array:

```swift
let myCookie = cookies[column, row]
```

Or change it:

```swift
cookies[column, row] = newCookie
```

Internally, `Array2D` uses a single one-dimensional array to store the data. The index of an object in that array is given by `(row x numberOfColumns) + column`. But as a user of `Array2D` you don't have to worry about that; you only have to think in terms of "column" and "row", and let `Array2D` figure out the details for you. That's the advantage of wrapping primitive types into a wrapper class or struct.

And that's all there is to it.

*Written for Swift Algorithm Club by Matthijs Hollemans*
