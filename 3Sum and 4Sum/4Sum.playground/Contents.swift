func FourSum(_ nums: [Int], target: Int) -> [[Int]] {
    let a = nums.sorted()
    var ret: [[Int]] = []
    
    for i in 0..<nums.count {
        if i != 0 && a[i] == a[i-1] {
            continue
        }
        for j in i+1..<nums.count {
            if j != i+1 && a[j] == a[j-1] {
                continue
            }
            
            var k = j + 1
            var t = nums.count - 1
            
            while k < t {
                let sum = a[i] + a[j] + a[k] + a[t]
                
                if sum == target {
                    ret.append([a[i], a[j], a[k], a[t]])
                    k += 1
                } else if sum < target {
                    k += 1
                } else {
                    t -= 1
                }
                
                if sum == target {
                    while k < t {
                        var flag = true
                        if k != j + 1 && a[k] == a[k-1] {
                            k += 1
                            flag = false
                        }
                        
                        if t != nums.count - 1 && a[t] == a[t+1] {
                            t -= 1
                            flag = false
                        }
                        
                        if flag {
                            break
                        }
                    }
                }
            }
        }
    }
    
    return ret
}

/* Answer
[
    [-1,  0, 0, 1],
    [-2, -1, 1, 2],
    [-2,  0, 0, 2]
]
*/
FourSum([1, 0, -1, 0, -2, 2], target: 0)
