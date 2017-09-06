//: Playground - noun: a place where people can play

// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

//protocol SegmentTree<T> {
//    func pushUp(lson: T, rson: T)
//    func pushDown(round: Int, lson: T, rson: T)
//}

public class LazySegmentTree {
    
    private var value: Int
    
    private var leftBound: Int
    
    private var rightBound: Int
    
    private var leftChild: LazySegmentTree?
    
    private var rightChild: LazySegmentTree?
    
    // Interval Update Lazy Element
    private var lazyValue: Int
    
    // MARK: - Push Up Operation
    // Description: 这里是 push up 操作，用来对 Segment Tree 向上更新
    private func pushUp(lson: LazySegmentTree, rson: LazySegmentTree) {
        self.value = lson.value + rson.value
    }
    
    // MARK: - Push Down Operation
    // Description: 这里是 push down 操作，用来对 Segment Tree 向下更新
    // Open Interface Function: 此处应该开放方法对齐进行 Override
    private func pushDown(round: Int, lson: LazySegmentTree, rson: LazySegmentTree) {
        if lazyValue != 0 {
            lson.lazyValue += lazyValue
            rson.lazyValue += lazyValue
            lson.value += lazyValue * (round - (round >> 1))
            rson.value += lazyValue * (round >> 1)
            lazyValue = 0
        }
    }
    
    public init(array: [Int], leftBound: Int, rightBound: Int) {
        self.leftBound = leftBound
        self.rightBound = rightBound
        self.value = 0
        self.lazyValue = 0
        
        if leftBound == rightBound {
            value = array[leftBound]
            return
        }
        
        let middle = (leftBound + rightBound) / 2
        leftChild = LazySegmentTree(array: array, leftBound: leftBound, rightBound: middle)
        rightChild = LazySegmentTree(array: array, leftBound: middle + 1, rightBound: rightBound)
        pushUp(lson: leftChild!, rson: rightChild!)
        
    }
    
    public convenience init(array: [Int]) {
        self.init(array: array, leftBound: 0, rightBound: array.count - 1)
    }
    
    public func query(leftBound: Int, rightBound: Int) -> Int {
        if leftBound <= self.leftBound && self.rightBound <= rightBound {
            return value
        }
        guard let leftChild  = leftChild  else { fatalError("leftChild should not be nil") }
        guard let rightChild = rightChild else { fatalError("rightChild should not be nil") }
        
        pushDown(round: self.rightBound - self.leftBound + 1, lson: leftChild, rson: rightChild)
        
        let middle = (self.leftBound + self.rightBound) / 2
        var result: Int = 0
        
        if leftBound <= middle { result +=  leftChild.query(leftBound: leftBound, rightBound: rightBound) }
        if rightBound > middle { result += rightChild.query(leftBound: leftBound, rightBound: rightBound) }
        
        return result
    }
    
    // MARK: - One Item Update
    public func update(index: Int, incremental: Int) {
        if self.leftBound == self.rightBound {
            self.value += incremental
            return
        }
        guard let leftChild  = leftChild  else { fatalError("leftChild should not be nil") }
        guard let rightChild = rightChild else { fatalError("rightChild should not be nil") }
        
        let middle = (self.leftBound + self.rightBound) / 2
        
        if index <= middle { leftChild.update(index: index, incremental: incremental) }
        else { rightChild.update(index: index, incremental: incremental) }
        pushUp(lson: leftChild, rson: rightChild)
    }
    
    // MARK: - Interval Item Update
    public func update(leftBound: Int, rightBound: Int, incremental: Int) {
        if leftBound <= self.leftBound && self.rightBound <= rightBound {
            self.lazyValue += incremental
            self.value += incremental * (self.rightBound - self.leftBound + 1)
            return 
        }
        
        guard let leftChild = leftChild else { fatalError() }
        guard let rightChild = rightChild else { fatalError() }
        
        pushDown(round: self.rightBound - self.leftBound + 1, lson: leftChild, rson: rightChild)
        
        let middle = (self.leftBound + self.rightBound) / 2
        
        if leftBound <= middle { leftChild.update(leftBound: leftBound, rightBound: rightBound, incremental: incremental) }
        if middle < rightBound { rightChild.update(leftBound: leftBound, rightBound: rightBound, incremental: incremental) }
        
        pushUp(lson: leftChild, rson: rightChild)
    }
    
}

let array = [1, 2, 3, 4, 1, 3, 2]

let sumSegmentTree = LazySegmentTree(array: array)

print(sumSegmentTree.query(leftBound: 0, rightBound: 3)) // 10 = 1 + 2 + 3 + 4
sumSegmentTree.update(index: 1, incremental: 2)
print(sumSegmentTree.query(leftBound: 0, rightBound: 3)) // 12 = 1 + 4 + 3 + 4
sumSegmentTree.update(leftBound: 0, rightBound: 2, incremental: 2)
print(sumSegmentTree.query(leftBound: 0, rightBound: 3)) // 18 = 3 + 6 + 5 + 4

for index in 2 ... 5 {
    sumSegmentTree.update(index: index, incremental: 3)
}


sumSegmentTree.update(leftBound: 0, rightBound: 5, incremental: 2)
print(sumSegmentTree.query(leftBound: 0, rightBound: 2))





