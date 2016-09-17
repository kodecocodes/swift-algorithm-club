//: Playground - noun: a place where people can play

// Playing with hash values

"firstName".hashValue
abs("firstName".hashValue) % 5

"lastName".hashValue
abs("lastName".hashValue) % 5

"hobbies".hashValue
abs("hobbies".hashValue) % 5

// Playing with the hash table

var hashTable = HashTable<String, String>(capacity: 5)

hashTable["firstName"] = "Steve"
hashTable["lastName"] = "Jobs"
hashTable["hobbies"] = "Programming Swift"

print(hashTable)
print(hashTable.debugDescription)

let x = hashTable["firstName"]
hashTable["firstName"] = "Tim"

let y = hashTable["firstName"]
hashTable["firstName"] = nil

let z = hashTable["firstName"]

print(hashTable)
print(hashTable.debugDescription)
