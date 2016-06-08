import Foundation

func createRandomList(numberOfElements: Int) -> [UInt32] {
  return (1...numberOfElements).map {_ in arc4random()}
}
