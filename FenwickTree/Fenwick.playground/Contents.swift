//: Playground - noun: a place where people can play

import UIKit

/**
Fenwick Tree

- Performance (n = size of array):
- Build with zeros: O(n)
- Build with array: O(n * log n)
- Query sum: O(log n)
- Query add: O(log n)

- Query index for minimum sum: O(log n)
*/
public class FenwickTree<T> {
	/// Holds values regarding to fenwick tree
	fileprivate(set) var fenwickTree: [T]
	/// Holds real values after updates
	fileprivate(set) var array: [T]
	fileprivate(set) let zero: T
	fileprivate let addFunction: (T, T) -> T
	fileprivate let subFunction: (T, T) -> T
	
	fileprivate let leastSignificantBit: (Int) -> Int = { $0 & -$0 }
	
	
	/**
	- Order: O(n)
	
	- Parameters:
	- size: size of array (not changable)
	- zero: array is filled with `.zero` values at the beginning. also this value will be returned
	when given intervals contain no elements.
	- addFunction: function used for adding elements. usually `+`
	- subFunction: function used for subtracting elements. usually `-`
	*/
	public required init(size: Int, zero: T, addFunction: @escaping (T, T) -> T, subFunction:  @escaping (T, T) -> T) {
		
		self.fenwickTree = Array<T>(repeating: zero, count: size)
		self.array = fenwickTree
		self.zero = zero
		self.addFunction = addFunction
		self.subFunction = subFunction
	}
	
	/**
	- Order: O(n * log n)
	
	- Parameters:
	- array: initial array to build fenwick tree based on them
	- zero: array is filled with `.zero` values at the beginning. also this value will be returned
	when given intervals contain no elements.
	- addFunction: function used for adding elements. usually `+`
	- subFunction: function used for subtracting elements. usually `-`
	*/
	public convenience init(array: [T], zero: T, addFunction: @escaping (T, T) -> T, subFunction:  @escaping (T, T) -> T) {
		
		self.init(size: array.count, zero: zero, addFunction: addFunction, subFunction: subFunction)
		
		for index in array.indices {
			add(itemAt: index, with: array[index])
		}
	}
	
	/**
	If `to` is out of bound, method return `.zero`. results are added together using `addFunction`
	
	Order: O(log n)
	
	- Parameter to: zero based index on array
	
	- Returns: sum of all elements in `0...to`.
	*/
	func sum(to: Int) -> T {
		guard to >= 0 && to < fenwickTree.count
			else {
				return zero
		}
		
		var sum = zero
		var index = to + 1
		while index > 0 {
			sum = addFunction(sum, fenwickTree[index - 1])
			index -= leastSignificantBit(index)
		}
		return sum
	}
	
	/**
	If `from >= to` method will return `.zero`. method finds two subranges `0...from-1` and `0...to` using
	`addFunction` and will subtract them using `subFunction`
	
	Order: O(log n)
	
	- Parameters:
	- from: zero based index on array
	- to: zero based index on array
	
	
	- Returns: sum of all elements `from...to`
	*/
	func sum(from: Int, to: Int) -> T {
		let leftSum = from == 0 ? zero : sum(to: from - 1)
		let rightSum = sum(to: to)
		return subFunction(rightSum, leftSum)
	}
	
	/**
	Adds element at given index with value using `addFunction`
	
		Order: O(log n)
	
	- Parameters:
	- itemAt: zero based index on array
	- with: given value to add to current element
	*/
	func add(itemAt index: Int, with value: T) {
		array[index] = addFunction(array[index], value)
		var index = index + 1
		while index <= fenwickTree.count {
			fenwickTree[index - 1] = addFunction(fenwickTree[index - 1], value)
			index += leastSignificantBit(index)
		}
		
	}
}

extension FenwickTree where T: Comparable {
	/**
	Searchs for first index in fenwick tree which sum of all elements in `0...index` is less or equal to `minimumSum`
	
	Order: O(log n)
	
	- Parameters:
	- minimumSum: minimum sum to serach for
	
	- Returns: zero based index which sum of all elements in `0...returnedValue` is at least `minimumSum`
	*/
	func index(forMinimumSum minSum: T) -> Int {
		var index = 1
		var localSum = zero
		while index != fenwickTree.count && addFunction(localSum, fenwickTree[index - 1]) < minSum {
			let lsb = leastSignificantBit(index)
			if index + lsb <= fenwickTree.count && addFunction(localSum, fenwickTree[index + lsb - 1]) < minSum {
				index += lsb
			}
			else {
				localSum = addFunction(localSum, fenwickTree[index - 1])
				index += 1
			}
		}
		return index - 1
	}
}

let fen = FenwickTree(array: [1, 1, 1, 1, 1, 1, 1, 1, 1], zero: 0, addFunction: +, subFunction: -)
/* or initialize it and add values one by one
	let fen = FenwickTree(size: 9, zero: 0, addFunction: +, subFunction: -)
	(0 ..< fen.array.count).forEach { fen.add(itemAt: $0, with: 1) }
*/


print(fen.fenwickTree)
for i in 0 ... (fen.fenwickTree.count + 1) {
	print(fen.index(forMinimumSum: i), terminator: " ")
}
print()

print(fen.sum(to: 4))
print(fen.sum(from: 1, to: 4))
fen.add(itemAt: 0, with: 2)
fen.add(itemAt: 3, with: -1)
print(fen.sum(to: 4))
print(fen.sum(from: 1, to: 4))

print(fen.fenwickTree)
print(fen.array)
for i in 0 ... (fen.fenwickTree.count + 1) {
	print(fen.index(forMinimumSum: i), terminator: " ")
}
print()






