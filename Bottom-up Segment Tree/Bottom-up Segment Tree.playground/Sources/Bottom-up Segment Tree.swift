/*
  Bottom-up Segment Tree

*/

import Foundation

public class BottomUpSegmentTree<T: InitializeWithoutParametersable>: CustomStringConvertible {
	private var arrayCount: Int!
	private var leavesCapacity: Int!
	private var function: (T, T) -> T
	private var associatedtypeInitValue: T!
	private var result: [T]!
	
	public init(array: [T], function: (T, T) -> T, associatedtypeInitValue: T) {
		self.function = function
		self.associatedtypeInitValue = associatedtypeInitValue
		self.arrayCount = array.count
		self.leavesCapacity = leavesCapacityUpdate(array)
		self.result = resultUpdate(array)
	}
	
	public init(array: [T], function: (T, T) -> T, associatedtypeNeedInitValue: Bool) {
		self.function = function
		if associatedtypeNeedInitValue {
			self.associatedtypeInitValue = T.nomalizeValue
		} else {
			self.associatedtypeInitValue = T()
		}
		self.arrayCount = array.count
		self.leavesCapacity = leavesCapacityUpdate(array)
		self.result = resultUpdate(array)
	}

	public convenience init(array: [T], function: (T, T) -> T) {
		self.init(array: array, function: function, associatedtypeNeedInitValue: false)
	}
	
	private func leavesCapacityUpdate(array: [T]) -> Int {
		var n = array.count - 1
		for i in 1...64 {
			n /= 2
			if n == 0 {
				return 1<<i
			}
		}
		return 0
	}
	
	private func resultUpdate(array: [T]) -> [T] {
		var result = [T](count: leavesCapacity * 2, repeatedValue: associatedtypeInitValue)
		for i in array.indices {
			result[leavesCapacity+i] = array[i]
		}
		for j in (leavesCapacity-1).stride(to: 0, by: -1) {
			result[j] = function(result[j << 1], result[(j << 1) + 1])
		}
		return result
	}

	// MARK: - query
	
	public func queryWithLeftBound(leftBound: Int, rightBound: Int) -> T {
		// 1
		guard leftBound >= 0 && leftBound <= arrayCount && rightBound >= 0 && rightBound <= arrayCount else { fatalError("index error") }
		guard leftBound <= rightBound else { fatalError("leftBound should be equal or less than rightBound") }
		// 2
		var s = leftBound + leavesCapacity - 1, t = rightBound + leavesCapacity + 1
		var ans = associatedtypeInitValue
		while s ^ t != 1 {
			// result will be effected if the sequence of input arguments is different
			ans = s & 1 == 0 ? function(ans, result[s+1]) : ans
			ans = t & 1 == 1 ? function(result[t-1], ans) : ans
			s>>=1
			t>>=1
		}
		return ans
	}
	
	public func queryWithRange(range: Range<Int>) -> T {
		return queryWithLeftBound(range.startIndex, rightBound: range.endIndex - 1)
	}

	// MARK: - Replace Item
	
	public func replaceItemAtIndex(index: Int, withItem item: T) {
		self.result[index + leavesCapacity] = item
		var j = (leavesCapacity + index)>>1
		while j > 0 {
			result[j] = function(result[j<<1], result[j<<1 + 1])
			j>>=1
		}
	}
	
	public func appendArray(newElement: T) {
		if arrayCount == leavesCapacity {
			var array = [T]()
			for i in leavesCapacity..<leavesCapacity<<1 {
				array.append(result[i])
			}
			array.append(newElement)
			self.leavesCapacity = leavesCapacityUpdate(array)
			self.result = resultUpdate(array)
		} else {
			replaceItemAtIndex(arrayCount, withItem: newElement)
			arrayCount =  arrayCount + 1
		}
	}

	// MARK: - Debugging, CustomStringConvertible
	
	public var description: String {
		return result.description
	}
}


// MARK: - Generic type

public protocol InitializeWithoutParametersable: Comparable {
	init()
	static var nomalizeValue: Self {get}
}
extension Int: InitializeWithoutParametersable {
	public static var nomalizeValue: Int {
		return 1
	}
}
extension Double: InitializeWithoutParametersable {
	public static var nomalizeValue: Double {
		return 1.0
	}
}
extension String: InitializeWithoutParametersable {
	public static var nomalizeValue: String {
		return ""
	}
}

