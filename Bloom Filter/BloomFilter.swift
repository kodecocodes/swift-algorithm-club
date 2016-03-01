import Foundation

public class BloomFilter<T> {
    private(set) private var arr: [Bool]
    private(set) private var hashFunctions: [T -> Int]
    
    public init(size: Int = 1024, hashFunctions: [T -> Int]) {
        self.arr = Array<Bool>(count: size, repeatedValue: false)
        self.hashFunctions = hashFunctions
    }
    
    private func computeHashes(value: T) -> [Int] {
        return hashFunctions.map() { hashFunc in
            abs(hashFunc(value) % self.arr.count)
        }
    }
    
    public func insert(toInsert: T) {
        let hashValues: [Int] = self.computeHashes(toInsert)
        
        for hashValue in hashValues {
            self.arr[hashValue] = true
        }
    }
    
    public func insert(values: [T]) {
        for value in values {
            self.insert(value)
        }
    }
    
    public func query(value: T) -> Bool {
        let hashValues = self.computeHashes(value)
        
        // Map hashes to indices in the Bloom filter
        let results = hashValues.map() { hashValue in
            self.arr[hashValue]
        }
        
        // All values must be 'true' for the query to return true

        // This does NOT imply that the value is in the Bloom filter,
        // only that it may be. If the query returns false, however,
        // you can be certain that the value was not added.

        let exists = results.reduce(true, combine: { $0 && $1 })
        
        return exists
    }
    
    public func isEmpty() -> Bool {
        // Reduce list; as soon as the reduction hits a 'true' value, the && condition will fail
        return arr.reduce(true) { prev, next in
            prev && !next
        }
    }
    
}