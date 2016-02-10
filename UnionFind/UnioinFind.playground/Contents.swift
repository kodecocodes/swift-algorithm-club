//: Playground - noun: a place where people can play

public struct UnionFind<T: Hashable> {
  
  private var index = [T:Int]()
  private var parent = [Int]()
  private var size = [Int]()
  
  
  public mutating func addSetWithElement(element: T) {
    index[element] = parent.count
    parent.append(parent.count)
    size.append(1)
  }
  
  private mutating func findSetByIndexOfElement(index: Int) -> Int {
    if parent[index] == index {
      return index
    } else {
      parent[index] = findSetByIndexOfElement(parent[index])
      return parent[index]
    }
  }
  
  public mutating func findSetOfElement(element: T) -> Int {
    let indexOfElement = index[element]!
    return findSetByIndexOfElement(indexOfElement)
  }
  
  public mutating func unionSetsWithElement(firstElement: T, andSecondElement secondElement: T) {
    let firstSet = findSetOfElement(firstElement)
    let secondSet = findSetOfElement(secondElement)
    if (firstSet != secondSet) {
      if (size[firstSet] < size[secondSet]) {
        parent[firstSet] = secondSet;
        size[secondSet] += size[firstSet]
      } else {
        parent[secondSet] = firstSet;
        size[firstSet] += size[secondSet]
      }
    }
  }
}


var dsu = UnionFind<Int>()

for i in 1...10 {
  dsu.addSetWithElement(i)
}
// now our dsu contains 10 independent sets

// let's divide our numbers into two sets by divisibility by 2
for i in 3...10 {
  if i % 2 == 0 {
    dsu.unionSetsWithElement(2, andSecondElement: i)
  } else {
    dsu.unionSetsWithElement(1, andSecondElement: i)
  }
}

// check our division
print(dsu.findSetOfElement(2) == dsu.findSetOfElement(4))
print(dsu.findSetOfElement(4) == dsu.findSetOfElement(6))
print(dsu.findSetOfElement(6) == dsu.findSetOfElement(8))
print(dsu.findSetOfElement(8) == dsu.findSetOfElement(10))

print(dsu.findSetOfElement(1) == dsu.findSetOfElement(3))
print(dsu.findSetOfElement(3) == dsu.findSetOfElement(5))
print(dsu.findSetOfElement(5) == dsu.findSetOfElement(7))
print(dsu.findSetOfElement(7) == dsu.findSetOfElement(9))

print(dsu.findSetOfElement(8) == dsu.findSetOfElement(9))
print(dsu.findSetOfElement(4) == dsu.findSetOfElement(3))


var dsuForStrings = UnionFind<String>()
let words = ["all", "border", "boy", "afternoon", "amazing", "awesome", "best"]

dsuForStrings.addSetWithElement("a")
dsuForStrings.addSetWithElement("b")

// In that example we divide strings by its first letter
for word in words {
  dsuForStrings.addSetWithElement(word)
  if word.hasPrefix("a") {
    dsuForStrings.unionSetsWithElement("a", andSecondElement: word)
  } else if word.hasPrefix("b") {
    dsuForStrings.unionSetsWithElement("b", andSecondElement: word)
  }
}

print(dsuForStrings.findSetOfElement("a") == dsuForStrings.findSetOfElement("all"))
print(dsuForStrings.findSetOfElement("all") == dsuForStrings.findSetOfElement("awesome"))
print(dsuForStrings.findSetOfElement("amazing") == dsuForStrings.findSetOfElement("afternoon"))

print(dsuForStrings.findSetOfElement("b") == dsuForStrings.findSetOfElement("boy"))
print(dsuForStrings.findSetOfElement("best") == dsuForStrings.findSetOfElement("boy"))
print(dsuForStrings.findSetOfElement("border") == dsuForStrings.findSetOfElement("best"))

print(dsuForStrings.findSetOfElement("amazing") == dsuForStrings.findSetOfElement("boy"))
print(dsuForStrings.findSetOfElement("all") == dsuForStrings.findSetOfElement("border"))




