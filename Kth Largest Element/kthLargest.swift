/*
* Returns the k-th largest value inside of an array a.
* This is an O(n log n) solution since we sort the array.
*/
func kthLargest(a: [Int], k: Int) -> Int? {
    let len = a.count
    
    if (k <= 0 || k > len || len < 1) { return nil }
    
    let sorted = a.sort()
    
    return sorted[len - k]
}
