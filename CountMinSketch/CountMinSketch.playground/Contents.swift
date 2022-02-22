//: # CountMin Sketch
import Foundation

/// Private wrapper around Hashing, allowing hash different Hashables and keep their value
private final class Hashing<T> where T: Hashable {
    private var map: [T: Int] = [:]
    
    func hash(_ value: T) -> Int {
        if let hash = map[value] {
            return hash
        }
        var hasher = Hasher()
        hasher.combine(value)
        let newValue = abs(hasher.finalize())
        map[value] = newValue
        return newValue
    }
}

/*
 A class for counting hashable items using the Count-min Sketch strategy.
 It fulfills a similar purpose than `itertools.Counter`.
 The Count-min Sketch is a randomized data structure that uses a constant
 amount of memory and has constant insertion and lookup times at the cost
 of an arbitrarily small overestimation of the counts.
*/
public final class CountMinSketch<T> where T: Hashable {
    private var hashers: [Hashing<T>] = []
    private var matrix: [[UInt64]] = []
    private let rows: Int
    private let cols: Int
    
    /// The total amount of elements adedd to the model
    private(set) var count: UInt64 = 0
    /// init - will determine the matrix size
    /// - Parameters:
    ///   - rows: the size of the hash tables, larger implies smaller overestimation
    ///   - cols: the amount of hash tables, larger implies lower probability of
    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        for _ in 0..<self.rows {
            hashers.append(Hashing())
            matrix.append([UInt64](repeating: 0, count: self.cols))
        }
    }
    
    /// Init - will determine the matrix size. s.t CountMin sketch guarantees approximation error on point queries more than epsilon * F1 (where F1 is the Frequency of first order of the stream) with probability `delta` in space O(1 \ epsilon * log(1 \ delta))
    /// - Parameters:
    ///   - delta: the probability for an error bigger than epsilon
    ///   - epsilon: the error from the actual value
    init(delta: CGFloat, epsilon: CGFloat) {
        self.rows = Int(log2(1/delta).rounded(.up))
        self.cols = Int((2/epsilon).rounded(.up))
        for _ in 0..<self.rows {
            hashers.append(Hashing())
            matrix.append([UInt64](repeating: 0, count: self.cols))
        }
    }
    
    // Adding elemets to count, by default we increase the element count by one
    // But we extended the API to allow increasing the count in batches
    
    /// Adding an element to the sketch
    /// - Parameters:
    ///   - element: the element to add, must conform to hashable (described by T in the class definition)
    ///   - value: the value (i.e amount) that we want to increase the element count by
    func add(element: T, value: UInt64=1) {
        self.count += value
        for row in 0..<self.rows {
            let hash = self.hashers[row].hash(element)
            let col = hash % self.cols
            self.matrix[row][col] += value
        }
    }
    
    /// Querying an element appearances
    /// - Parameter element: the element we want to get an estimation for
    /// - Returns: estimation of the amount of time that elememt was `add`
    func query(element: T) -> UInt64 {
        var values = [UInt64]()
        for row in 0..<self.rows {
            let hash = self.hashers[row].hash(element)
            let col = hash % self.cols
            let value = self.matrix[row][col]
            values.append(value)
        }
        return values.min()!
    }
}


//: EXAMPLES
//: Let's create a sketch

let stream: [Int] = [
    1,2,3,4,5,5 ,1,23,43,23,4534,345,234,2,3423,234,23,42,453,45,345,23,2,343,45,345,34
]

let sketch = CountMinSketch<Int>(rows: 10, cols: 10)

for element in stream {
    sketch.add(element: element)
}

assert(sketch.count == stream.count)

print("We have \(sketch.count) elements in the stream")


print("The frequency of 1 is \(sketch.query(element: 1))")
