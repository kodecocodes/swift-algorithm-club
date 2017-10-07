func ThreeSum(_ nums: [Int], targetSum: Int) -> [[Int]] {
    var a = nums.sorted()
    var ret: [[Int]] = []
    
    for m in 0..<a.count {
        if m != 0 && a[m] == a[m-1] {
            continue
        }
        
        var l = m + 1
        var r = nums.count - 1
        
        while l < r {
            let sum = a[m] + a[l] + a[r]
            
            if sum == targetSum {
                ret.append([a[m], a[l], a[r]])
                l += 1
            } else if sum < targetSum {
                l += 1
            } else {
                r -= 1
            }
            
            if sum == targetSum {
                while l < r {
                    var flag = false
                    if l != 0 && a[l] == a[l-1] {
                        l += 1
                        flag = true
                    }
                    
                    if (r != a.count - 1) && a[r] == a[r+1] {
                        r -= 1
                        flag = true
                    }
                    
                    if (!flag) {
                        break
                    }
                }
            }
        }
    }
    
    return ret
}

// Answer: [[-1, 0, 1], [-1, -1, 2]]
ThreeSum([-1, 0, 1, 2, -1, -4], targetSum: 0)

// Answer: [[-1, -1, 1]]
ThreeSum([-1, 1, 1, -1], targetSum: 1)

// Answer: [[-1, -1, 2], [-1, 0, 1]]
ThreeSum([-1, -1, -1, -1, 2, 1, -4, 0], targetSum: 0)

// Answer: [[-1, -1, 2]]
ThreeSum([-1, -1, -1, -1, -1, -1, 2], targetSum: 0)
