import Foundation

public func randomize(n: Int) -> [Int] {
    var unsorted = [Int]()
    for _ in 0..<n {
        unsorted.append(Int(arc4random()))
    }
    return unsorted
}
