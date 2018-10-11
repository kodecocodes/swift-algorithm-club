//: Playground - noun: a place where people can play
// Test for  the RedBlackTree implementation provided in the Source folder of this Playground
import Foundation

let redBlackTree = RedBlackTree<Double>()

let randomMax = Double(0x10000000)
var values = [Double]()
for i in 0..<1000 {
  let value = Double(arc4random()) / randomMax
  values.append(value)
  redBlackTree.insert(key: value)
  
  if i % 100 == 0 {
    redBlackTree.verify()
  }
}
redBlackTree.verify()

for i in 0..<1000 {
  let rand = arc4random_uniform(UInt32(values.count))
  let index = Int(rand)
  let value = values.remove(at: index)
  redBlackTree.delete(key: value)
  
  if i % 100 == 0 {
    redBlackTree.verify()
  }
}
redBlackTree.verify()
