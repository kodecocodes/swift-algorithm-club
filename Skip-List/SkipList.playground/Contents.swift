// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

// SkipList is ready for Swift 4.
// TODO: Add Test

let k = SkipList<Int, String>()
k.insert(key: 10, data: "10")
k.insert(key: 12, data: "12")
k.insert(key: 13, data: "13")
k.insert(key: 20, data: "20")
k.insert(key: 24, data: "24")

if let value = k.get(key: 20) {
  print(value)
} else {
  print("not found!")
}
