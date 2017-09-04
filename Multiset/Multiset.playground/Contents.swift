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

