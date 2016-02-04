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

let a = [5, 1, 3, 2, 7, 6, 4]

kthLargest(a, k: 0)
kthLargest(a, k: 1)
kthLargest(a, k: 2)
kthLargest(a, k: 3)
kthLargest(a, k: 4)
kthLargest(a, k: 5)
kthLargest(a, k: 6)
kthLargest(a, k: 7)
kthLargest(a, k: 8)
