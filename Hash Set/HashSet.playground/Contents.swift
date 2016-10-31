//: Playground - noun: a place where people can play

var set = HashSet<String>()

set.insert("one")
set.insert("two")
set.insert("three")
set.allElements()

set.insert("two")
set.allElements()

set.contains("one")
set.remove("one")
set.allElements()
set.contains("one")

/* Union */

var setA = HashSet<Int>()
setA.insert(1)
setA.insert(2)
setA.insert(3)
setA.insert(4)

var setB = HashSet<Int>()
setB.insert(3)
setB.insert(4)
setB.insert(5)
setB.insert(6)

let union = setA.union(setB)
union.allElements()          // [5, 6, 2, 3, 1, 4]

/* Intersection */

let intersection = setA.intersect(setB)
intersection.allElements()               // [3, 4]

/* Difference */

let difference1 = setA.difference(setB)
difference1.allElements()                // [2, 1]

let difference2 = setB.difference(setA)
difference2.allElements()                // [5, 6]
