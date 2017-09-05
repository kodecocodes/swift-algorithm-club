//: Playground - noun: a place where people can play

#if swift(>=4.0)
  print("Hello, Swift 4!")
#endif

import Cocoa

var set = Multiset<String>()

set.add("Foo")
set.add("Foo")
set.add("Bar")
set.add("Baz")

set.count
set.count(for: "Foo")

set.allItems

var set2 = Multiset<String>()
set2.add("Foo")
set2.add("Foo")

set2.isSubSet(of: set) // true
set.isSubSet(of: set2) // false
