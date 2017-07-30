//: Playground - noun: a place where people can play

let s = MergeKSortedList<Int>()

let a = LinkedList<Int>()

for i in 0..<5 {
    a.append(i)
}

let b = LinkedList<Int>()
b.append(2)
b.append(4)
b.append(6)

let c = LinkedList<Int>()

for i in 0..<10 {
    c.append(i)
}

s.mergeLists([a, b, c])
// [0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 5, 6, 6, 7, 8, 9]

let d = LinkedList<Int>()
for i in 0..<5 {
    d.append(i)
}
s.mergeLists([d])
// [0, 1, 2, 3, 4]

s.mergeLists([nil])
// nil
