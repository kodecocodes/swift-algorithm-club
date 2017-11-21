let s = AppleOrderedSet<Int>()

s.add(1)
s.add(2)
s.add(-1)
s.add(0)
s.insert(4, at: 3)

s.set(-1, at: 0)
s.remove(-1)

print(s.object(at: 1))

