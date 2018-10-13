//: Playground - noun: a place where people can play

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

// Convenience constructor: pass a Collection of Hashables to the constructor
var cacti = Multiset<Character>("cacti")
cacti.allItems
var tactical = Multiset<Character>("tactical")
cacti.isSubSet(of: tactical) // true
tactical.isSubSet(of: cacti) // false

// Test ExpressibleByArrayLiteral protocol
let set3: Multiset<String> = ["foo", "bar"]
set3.count(for: "foo")

// Test Equatable protocol
let set4 = Multiset<String>(set3.allItems)
set4 == set3 // true
set4 == set // false
