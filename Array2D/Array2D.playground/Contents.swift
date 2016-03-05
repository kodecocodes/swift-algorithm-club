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
    
    public subscript(column: Int, row: Int)  -> T {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }

}

// initialization
var Array2DNumbers = Array2D(columns: 3, rows: 5, initialValue: 0)

// makes an array of rows * columns elements all filled with zero
print(Array2DNumbers.array)

// setting numbers using subscript [x, y]
Array2DNumbers[0, 0] = 1
Array2DNumbers[1, 0] = 2

Array2DNumbers[0, 1] = 3
Array2DNumbers[1, 1] = 4

Array2DNumbers[0, 2] = 5
Array2DNumbers[1, 2] = 6

Array2DNumbers[0, 3] = 7
Array2DNumbers[1, 3] = 8
Array2DNumbers[2, 3] = 9

// now the numbers are set in the array
print(Array2DNumbers.array)

// print out the 2D array with a reference around the grid
for i in 0..<Array2DNumbers.rows {
    print("[", terminator: "");
    for j in 0..<Array2DNumbers.columns {
        if (j == Array2DNumbers.columns - 1) {
            print("\(Array2DNumbers[j, i])", terminator: "");
        } else {
            print("\(Array2DNumbers[j, i]) ", terminator: "");
        }
    }
    print("]");
}



