// last checked with Xcode 9.0b5
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

import Foundation

let tree = QuadTree(rect: Rect(origin: Point(0, 0), size: Size(xLength: 10, yLength: 10)))

for _ in 0..<40 {
  let randomX = Double(arc4random_uniform(100)) / 10
  let randomY = Double(arc4random_uniform(100)) / 10
  let point = Point(randomX, randomY)
  tree.add(point: point)
}

print(tree)
print(tree.points(inRect: Rect(origin: Point(1, 1), size: Size(xLength: 5, yLength: 5))))
