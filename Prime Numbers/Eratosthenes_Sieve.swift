infix operator ^^ { associativity left precedence 160 }
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(CGFloat(radix), CGFloat(power)))
}

infix operator .. {associativity left precedence 60 }

func ..<T: Strideable>(left: T, right: T.Stride) -> (T, T.Stride) {
    return (left, right)
}

func ..<T: Strideable>(left: (T, T.Stride), right: T) -> [T] {
    return [T](left.0.stride(through: right, by: left.1))
}


func primesTo(max: Int) -> [Int] {
    let m = Int(sqrt(ceil(Double(max))))
    let set = NSMutableSet(array: 3..2..max)
    set.addObject(2)
    for i in (2..1..m) {
        if (set.containsObject(i)) {
            for j in i^^2..i..max {
                set.removeObject(j)
            }
        }
    }
    return set.sortedArrayUsingDescriptors([NSSortDescriptor(key: "integerValue", ascending: true)]) as! [Int]
}