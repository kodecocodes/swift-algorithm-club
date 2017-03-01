//: Playground - noun: a place where people can play

public struct UnionFind<T: Hashable> {
  private var index = [T: Int]()
  private var parent = [Int]()
  private var size = [Int]()

  public mutating func addSetWith(_ element: T) {
    index[element] = parent.count
    parent.append(parent.count)
    size.append(1)
  }

  private mutating func setByIndex(_ index: Int) -> Int {
    if parent[index] == index {
      return index
    } else {
      parent[index] = setByIndex(parent[index])
      return parent[index]
    }
  }

  public mutating func setOf(_ element: T) -> Int? {
    if let indexOfElement = index[element] {
      return setByIndex(indexOfElement)
    } else {
      return nil
    }
  }

  public mutating func unionSetsContaining(_ firstElement: T, and secondElement: T) {
    if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
      if firstSet != secondSet {
        if size[firstSet] < size[secondSet] {
          parent[firstSet] = secondSet
          size[secondSet] += size[firstSet]
        } else {
          parent[secondSet] = firstSet
          size[firstSet] += size[secondSet]
        }
      }
    }
  }

  public mutating func inSameSet(_ firstElement: T, and secondElement: T) -> Bool {
    if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
      return firstSet == secondSet
    } else {
      return false
    }
  }
}




var dsu = UnionFind<Int>()

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



var dsuForStrings = UnionFind<String>()
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
