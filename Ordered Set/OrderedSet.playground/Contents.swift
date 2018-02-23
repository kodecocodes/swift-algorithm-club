let s = OrderedSet<Int>()

s.add(1)
s.add(2)
s.add(-1)
s.add(0)
s.insert(4, at: 3)

print(s.all()) // [1, 2, -1, 4, 0]

s.set(-1, at: 0) // We already have -1 in index: 2, so we will do nothing here

print(s.all()) // [1, 2, -1, 4, 0]

s.remove(-1)

print(s.all()) // [1, 2, 4, 0]

print(s.object(at: 1)) // 2

print(s.object(at: 2)) // 4

