import Foundation

/**
 Complexity:
 Time: O(n) - where n is the total number of elements in the 2D array
 Space: O(n)
 */

/// Iterative Spiral Matrix traversal
/// - Parameter array: 2D input array
/// - Returns: One-dimensional result array
func spiralTraverseIterative(array: [[Int]]) -> [Int] {
    if array.count == 0 { return [] }
    
    var result = [Int]()
    
    var startRow = 0
    var startCol = 0
    var endRow = array.count - 1
    var endCol = array[0].count - 1
    
    while startRow <= endRow, startCol <= endCol {
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
        
        for row in stride(from: endRow - 1, through: startCol + 1, by: -1) {
            if startCol == endCol { break }
            result.append(array[row][startCol])
        }
        
        startRow += 1
        endRow -= 1
        startCol += 1
        endCol -=  1
    }
    
    return result
}


/// Recursive Spiral Matrix traversal
/// - Parameter array: 2D array
/// - Returns: One-dimensional array of all elements from the 2D array traversed in spiral order.
func spiralTraverseRecursive(array: [[Int]]) -> [Int] {
    var result = [Int]()
    spiralHelper(array, 0, array.count - 1, 0, array[0].count - 1, &result)
    return result
}

/// Spiral traversal helper function
/// - Parameters:
///   - array: 2D array
///   - startRow: Index of starting row
///   - endRow: Index of last row
///   - startCol: Index of first column
///   - endCol: index of last column
///   - result: One-dimensional result array.
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


///Test
let array = [
    [1,2,3,4],
    [12,13,14,5],
    [11,16,15,6],
    [10,9,8,7]
]
spiralTraverseIterative(array: array)
spiralTraverseRecursive(array: array)
