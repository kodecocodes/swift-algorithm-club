
func maximumSubarray<T:Numeric & Comparable>(_ numbers:[T]) -> T{
    
    var best = numbers[0]
    var current = numbers[0]
    
    for i in 1..<numbers.count{
        current = max(current + numbers[i], numbers[i])
        best = max(current, best);
    }
    return best
}


maximumSubarray([-2, 1, -3, 4, -1, 2, 1, -5, 4])
