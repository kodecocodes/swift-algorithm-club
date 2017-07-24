//: Playground - noun: a place where people can play

let cache = LFUCache<Int>(2)
cache.set(1, val: 1)
cache.set(2, val: 2)
cache.get(1) // return 1
cache.set(3, val: 3) // remove key 2
cache.get(2) // return nil
cache.get(3) // return 3
cache.set(4, val: 4) // return key 1
cache.get(1) // return nil
cache.get(3) // return 3
cache.get(4) // return 4
