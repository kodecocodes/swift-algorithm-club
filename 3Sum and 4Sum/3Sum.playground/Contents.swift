func ThreeSum(_ nums: [Int], targetSum: Int) -> [[Int]] {
    var a = nums.sorted()
    var ret: [[Int]] = []
    
    for i in 0..<a.count {
        if i != 0 && a[i] == a[i-1] {
            continue
        }
        
        var j = i + 1
        var k = nums.count - 1
        
        while j < k {
            let sum = a[i] + a[j] + a[k]
            
            if sum == targetSum {
                ret.append([a[i], a[j], a[k]])
                j += 1
            } else if sum < targetSum {
                j += 1
            } else {
                k -= 1
            }
            
            if sum == targetSum {
                while j < k {
                    var flag = false
                    if j != 0 && a[j] == a[j-1] {
                        j += 1
                        flag = true
                    }
                    
                    if (k != a.count - 1) && a[k] == a[k+1] {
                        k -= 1
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
