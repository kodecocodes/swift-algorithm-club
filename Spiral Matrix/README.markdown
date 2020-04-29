
## Goal
Traverse a 2D array in spiral order.

## Overview
Given a 2D array, which can be a square array with `n == m`,  we want to return a one-dimensional array of all the elements of the 2D array in spiral order.

Spiral order will start at the top left corner of the 2D array move all the way to the right-most column on that row, then continue in a spiral pattern all the way until every element has been visited.

![spiral-matrix](Images/spiral-matrix.jpg)

## Example
Given the 2D array

```swift
array = [
    [1, 2, 3, 4],
    [12, 13, 14, 5],
    [11, 16, 15, 6],
    [10, 9, 8, 7]
]
```

we want to traverse this in spiral order and return the following one-dimensional array

```swift
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
```

## Iterative approach
We want to traverse this in clockwise spiral order. We go from the outer-most ‘layer’ to the inner-most ‘ layer’.  

Let’s hold the indices of

```swift
var startRow = 0
var startCol = 0
var endRow = array.count - 1
var endCol = array[0].count - 1
```

The order in which we will move through the first layer of the spiral using these indices is

### Steps

1. Loop while `startRow <= endRow, startCol <= endCol`
2. Horizontally traverse towards the right from `startCol` to (inclusive) `endCol`  by `1`.
3. Vertically traverse down from `startRow + 1`  to (inclusive) `endRow`  by `1` .
4. Horizontally traverse towards the left from `endCol - 1`  to (inclusive) `startCol` by `-1`.
5. Vertically traverse up from `endRow - 1` to (inclusive) `startCol + 1` by `-1`.
6. Increment indices `startRow += 1` `startCol += 1`
7. Decrement indices `endRow -= 1` `endCol -= 1`

### Edge cases
The matrix may have single row or a single columns in the middle. In this case, we don’t want to double-count values during step `4` and `5`, which we have already counted in step `2` and `3`. We will do an index check in both cases and break if it is true.

### Code

```swift
func spiralTraverse(array: [[Int]]) -> [Int] {
    guard array.count != 0 else { return [] }
    
    var result = [Int]()
    var startRow = 0
    var endRow = array.count - 1
    var startCol = 0
    var endCol = array[0].count - 1
    
    while startRow <= endRow, startCol <= endCol {
        for col in stride(from: startCol, through: endCol, by: 1) {
            result.append(array[startRow][col])
        }
        
        for row in stride(from: startRow + 1, through: endRow, by: 1) {
            result.append(array[row][endCol])
        }
        
        for col in stride(from: endCol - 1, through: startCol, by: -1) {
            if startRow == endRow {
                break
            }
            result.append(array[endRow][col])
        }
        
        for row in stride(from: endRow - 1, through: startRow + 1, by: -1) {
            if startCol == endCol {
                break
            }
            result.append(array[row][startCol])
        }
        
        startRow += 1
        endRow -= 1
        startCol += 1
        endCol -= 1
    }
    return result
}
```

## Recursive approach
Now let’s check out the recursive implementation of the algorithm. In this version we don’t need to maintain and update indices since we will be calling the function recursively based on different values.

### Code
```swift
func spiralTraverse(array: [[Int]]) -> [Int] {
    var result = [Int]()
    spiralHelper(array, 0, array.count - 1, 0, array[0].count - 1, &result)
    return result
}

func spiralHelper(_ array: [[Int]], _ startRow: Int, _ endRow: Int, _ startCol: Int, _ endCol: Int, _ result: inout [Int]) {
    if startRow > endRow || startCol > endCol {
        return
    }
    
    for col in stride(from: startCol, through: endCol, by: 1) {
        result.append(array[startRow][col])
    }
    
    for row in stride(from: startRow + 1, through: endRow, by: 1) {
        result.append(array[row][endCol])
    }
    
    for col in stride(from: endCol - 1, through: startCol, by: -1) {
        if startRow == endRow { break }
        result.append(array[endRow][col])
    }
    
    for row in stride(from: endRow - 1, through: startRow + 1, by: -1) {
        if startCol == endCol { break }
        result.append(array[row][startCol])
    }
    
    spiralHelper(array, startRow + 1, endRow - 1, startCol + 1, endCol - 1, &result)
}
```

## Test

```swift
let array = [
    [1,2,3,4],
    [12,13,14,5],
    [11,16,15,6],
    [10,9,8,7]
]
spiralTraverse(array: array)
```

## Complexity

* Time: `O(n)` - where `n` is the total number of elements in the 2D array
* Space: `O(n)` - since we are storing every element of the 2D array into a one-dimensional array
---
Written for Swift Algorithm Club by Azhar Anwar
