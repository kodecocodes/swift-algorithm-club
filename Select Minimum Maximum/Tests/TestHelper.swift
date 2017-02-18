import Foundation

func createRandomList(_ numberOfElements: Int) -> [UInt32] {
  return (1...numberOfElements).map {_ in arc4random()}
}
