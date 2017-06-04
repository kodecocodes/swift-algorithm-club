//: Playground - noun: a place where people can play

var dsu = UnionFindQuickUnion<Int>()

for i in 1...10 {
  dsu.addSetWith(i)
}
// now our dsu contains 10 independent sets

// let's divide our numbers into two sets by divisibility by 2
for i in 3...10 {
  if i % 2 == 0 {
    dsu.unionSetsContaining(2, and: i)
  } else {
    dsu.unionSetsContaining(1, and: i)
  }
}

// check our division
print(dsu.inSameSet(2, and: 4))
print(dsu.inSameSet(4, and: 6))
print(dsu.inSameSet(6, and: 8))
print(dsu.inSameSet(8, and: 10))

print(dsu.inSameSet(1, and: 3))
print(dsu.inSameSet(3, and: 5))
print(dsu.inSameSet(5, and: 7))
print(dsu.inSameSet(7, and: 9))

print(dsu.inSameSet(7, and: 4))
print(dsu.inSameSet(3, and: 6))

var dsuForStrings = UnionFindQuickUnion<String>()
let words = ["all", "border", "boy", "afternoon", "amazing", "awesome", "best"]

dsuForStrings.addSetWith("a")
dsuForStrings.addSetWith("b")

// In that example we divide strings by its first letter
for word in words {
  dsuForStrings.addSetWith(word)
  if word.hasPrefix("a") {
    dsuForStrings.unionSetsContaining("a", and: word)
  } else if word.hasPrefix("b") {
    dsuForStrings.unionSetsContaining("b", and: word)
  }
}

print(dsuForStrings.inSameSet("a", and: "all"))
print(dsuForStrings.inSameSet("all", and: "awesome"))
print(dsuForStrings.inSameSet("amazing", and: "afternoon"))

print(dsuForStrings.inSameSet("b", and: "boy"))
print(dsuForStrings.inSameSet("best", and: "boy"))
print(dsuForStrings.inSameSet("border", and: "best"))

print(dsuForStrings.inSameSet("amazing", and: "boy"))
print(dsuForStrings.inSameSet("all", and: "border"))
