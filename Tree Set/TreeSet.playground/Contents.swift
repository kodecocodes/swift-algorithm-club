//: Playground - noun: a place where people can play

// Set

var s = TreeSet<Int>()
for i in 0..<10 {
    s.insert(i)
}

s.allElements() // 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

s.insert(0)

s.allElements() // 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

s.contains(0) // true

s.remove(1)

s.contains(1) // false


// MultiSet

var multiS = TreeSet<Int>(true)
multiS.insert(0)
multiS.insert(0)

multiS.allElements() // 0, 0
