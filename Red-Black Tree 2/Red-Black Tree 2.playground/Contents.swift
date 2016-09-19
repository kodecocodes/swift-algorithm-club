//: Playground - noun: a place where people can play
import Foundation

let tree = RBTree<Double>()
let randomMax = Double(0x100000000)
var values = [Double]()
for _ in 0..<1000 {
    let value = Double(arc4random()) / randomMax
    values.append(value)
    tree.insert(value)
}
tree.verify()
 
for _ in 0..<1000 {
    let rand = arc4random_uniform(UInt32(values.count))
    let index = Int(rand)
    let value = values.remove(at: index)
    tree.delete(value)
}
tree.verify()
