//: Playground - noun: a place where people can play

let linkedList = LinkedList<Int>()
linkedList.append(1)
linkedList.append(2)
// 1 --> 2

// Hash
let cycleWithHash = LinkedListCycle1WithHash<Int>(linkedList)
cycleWithHash.hasCycle()

let cycleList = LinkedList<Int>()
cycleList.append(1)
cycleList.append(2)
cycleList.append(3)

let first = cycleList.first!
let last = cycleList.last!
last.next = first

ObjectIdentifier(first)
ObjectIdentifier(first.next!)
ObjectIdentifier(last)
ObjectIdentifier(last.next!)

//var s = Set<LinkedList<Int>.LinkedListNode<Int>>()
//s.insert(first)
//s.insert(last)
//s.insert(first)
//for element in s {
//    print(ObjectIdentifier(element).hashValue)
//}

// TODO: Expalin why deadlock, remove extension from linkedlist. Guess Sequence extension
// TODO: Why == and === will be different in Equatal, == case error
let cycleWithHash2 = LinkedListCycle1WithHash<Int>(cycleList)
cycleWithHash2.hasCycle()


// 2 Pointers
let cycleWith2Pointers = LinkedListCycle1With2Pointers<Int>(linkedList)
cycleWith2Pointers.hasCycle()

let cycleWith2Pointers2 = LinkedListCycle1With2Pointers<Int>(cycleList)
cycleWith2Pointers2.hasCycle()


// Hash - Cycle 2
let cycle2WithHash = LinkedListCycle2WithHash<Int>(linkedList)
cycle2WithHash.meetPointer()

let cycle2WithHash2 = LinkedListCycle2WithHash<Int>(cycleList)
cycle2WithHash2.meetPointer()

// 2 Pointers - Cycle 2
let cycle2With2Pointers = LinkedListCycle2With2Pointers<Int>(linkedList)
cycle2With2Pointers.meetPointer()

let cycle2With2Pointers2 = LinkedListCycle2With2Pointers<Int>(cycleList)
cycle2With2Pointers2.meetPointer()
