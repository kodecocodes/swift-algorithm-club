//: Playground - noun: a place where people can play

class SingleNumber {
    func findNumber(_ a: [Int]) -> Int {
        var ret = 0
        for num in a {
            ret = ret ^ num
        }
        
        return ret
    }
}

let s = SingleNumber()
s.findNumber([1, 1, 2, 2, 3]) // 3
s.findNumber([1]) // 1


class SingleNumber2 {
    func findNumber(_ a: [Int]) -> Int {
        var ret = 0
        for i in 0..<32 {
            let mask = 1 << i
            var sum = 0
            for num in a {
                if num & mask != 0 {
                    sum += 1
                }
            }
            
            if sum % 3 == 1 {
                ret = ret | mask
            }
        }
        
        return ret
    }
}

let s2 = SingleNumber2()
s2.findNumber([14, 14, 14, 9]) // 9

class SingleNumber3 {
    func findNumber(_ a: [Int]) -> (Int, Int) {
        var ret = 0
        for num in a {
            ret = ret ^ num
        }
        
        var mask = 1
        while (true) {
            if mask & ret != 0 {
                break
            }
            mask <<= 1
        }
        
        var num1 = 0
        var num2 = 0
        
        for num in a {
            if num & mask == 0 {
                num1 = num1 ^ num
            } else {
                num2 = num2 ^ num
            }
        }
        
        return (num1, num2)
    }
}

let s3 = SingleNumber3()
s3.findNumber([1, 2, 1, 3, 2, 5]) // (3, 5)


