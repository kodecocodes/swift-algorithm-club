import Foundation

public func slowSort(_ i: Int, _ j: Int, _ numberList: inout [Int]) {
  guard i < j else { return }
    
  let m = (i+j)/2
  slowSort(i, m, &numberList)
  slowSort(m+1, j, &numberList)
  if numberList[j] < numberList[m] {
    let temp = numberList[j]
    numberList[j] = numberList[m]
    numberList[m] = temp
  }
  slowSort(i, j-1, &numberList)
}
