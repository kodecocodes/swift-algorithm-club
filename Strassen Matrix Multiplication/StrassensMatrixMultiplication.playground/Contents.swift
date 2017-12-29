//: Playground - noun: a place where people can play

// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

import Foundation

var A = Matrix(rows: 2, columns: 4, initialValue: 0)
A[.row, 0] = [2, 3, -1, 0]
A[.row, 1] = [-7, 2, 1, 10]

var B = Matrix(rows: 4, columns: 2, initialValue: 0)
print(B)
B[.column, 0] = [3, 2, -1, 2]
B[.column, 1] = [4, 1, 2, 7]

let C = A.matrixMultiply(by: B)
let D = A.strassenMatrixMultiply(by: B)
let E = B.matrixMultiply(by: A)
let F = B.strassenMatrixMultiply(by: A)
print(C)
print(D)
print(E)
print(F)
