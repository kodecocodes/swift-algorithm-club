//
//  RootishArrayStack
//
//  Created by @BenEmdon on 2016-11-07.
//

import Darwin

public struct RootishArrayStack<T> {

	// MARK: - Instance variables

	fileprivate var blocks = [Array<T?>]()
	fileprivate var internalCount = 0

	// MARK: - Init

	public init() { }

	// MARK: - Calculated variables

	var count: Int {
		return internalCount
	}

	var capacity: Int {
		return blocks.count * (blocks.count + 1) / 2
	}

	var isEmpty: Bool {
		return blocks.count == 0
	}

	var first: T? {
		guard capacity > 0 else { return nil }
		return blocks[0][0]
	}

	var last: T? {
		guard capacity > 0 else { return nil }
		let block = self.block(fromIndex: count - 1)
		let innerBlockIndex = self.innerBlockIndex(fromIndex: count - 1, fromBlock: block)
		return blocks[block][innerBlockIndex]
	}

	// MARK: - Equations

	fileprivate func block(fromIndex index: Int) -> Int {
		let block = Int(ceil((-3.0 + sqrt(9.0 + 8.0 * Double(index))) / 2))
		return block
	}

	fileprivate func innerBlockIndex(fromIndex index: Int, fromBlock block: Int) -> Int {
		return index - block * (block + 1) / 2
	}

	// MARK: - Behavior

	fileprivate mutating func growIfNeeded() {
		if capacity - blocks.count < count + 1 {
			let newArray = [T?](repeating: nil, count: blocks.count + 1)
			blocks.append(newArray)
		}
	}

	fileprivate mutating func shrinkIfNeeded() {
		if capacity + blocks.count >= count {
			while blocks.count > 0 && (blocks.count - 2) * (blocks.count - 1) / 2 >= count {
				blocks.remove(at: blocks.count - 1)
			}
		}
	}

	public subscript(index: Int) -> T {
		get {
			let block = self.block(fromIndex: index)
			let innerBlockIndex = self.innerBlockIndex(fromIndex: index, fromBlock: block)
			return blocks[block][innerBlockIndex]!
		}
		set(newValue) {
			let block = self.block(fromIndex: index)
			let innerBlockIndex = self.innerBlockIndex(fromIndex: index, fromBlock: block)
			blocks[block][innerBlockIndex] = newValue
		}
	}

	public mutating func insert(element: T, atIndex index: Int) {
		growIfNeeded()
		internalCount += 1
		var i = count - 1
		while i > index {
			self[i] = self[i - 1]
			i -= 1
		}
		self[index] = element
	}

	public mutating func append(element: T) {
		insert(element: element, atIndex: count)
	}

	fileprivate mutating func makeNil(atIndex index: Int) {
		let block = self.block(fromIndex: index)
		let innerBlockIndex = self.innerBlockIndex(fromIndex: index, fromBlock: block)
		blocks[block][innerBlockIndex] = nil
	}

	public mutating func remove(atIndex index: Int) -> T {
		let element = self[index]
		for i in index..<count - 1 {
			self[i] = self[i + 1]
		}
		internalCount -= 1
		makeNil(atIndex: count)
		shrinkIfNeeded()
		return element
	}

	// MARK: - Struct to string

	public var memoryDescription: String {
		var description = "{\n"
		for block in blocks {
			description += "\t["
			for index in 0..<block.count {
				description += "\(block[index])"
				if index + 1 != block.count {
					description += ", "
				}
			}
			description += "]\n"
		}
		return description + "}"
	}
}

extension RootishArrayStack: CustomStringConvertible {
	public var description: String {
		var description = "["
		for index in 0..<count {
			description += "\(self[index])"
			if index + 1 != count {
				description += ", "
			}
		}
		return description + "]"
	}
}
