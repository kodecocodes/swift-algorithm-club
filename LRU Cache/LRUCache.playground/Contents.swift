let cache = LRUCache<String>(2)
cache.set("a", val: 1)
cache.set("b", val: 2)
cache.get("a") // returns 1
cache.set("c", val: 3) // evicts key "b"
cache.get("b") // returns nil (not found)
cache.set("d", val: 4) // evicts key "a"
cache.get("a") // returns nil (not found)
cache.get("c") // returns 3
cache.get("d") // returns 4
