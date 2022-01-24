let array = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]

let tree = BinaryIndexedTree<Double>(array: array)

// calculates the sum within [0-5] inclusive. Should be 21
tree.query(from: 0, to: 5)

// updates value at index 4 from 5.0 to 0.5
tree.update(at: 4, with: 0.5)

// calculates the sum within [0-5] inclusive. Should be 16.5
tree.query(from: 0, to: 5)

