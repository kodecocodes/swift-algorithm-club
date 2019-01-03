//
//  SlowSort.swift
//  
//
//  Created by Pope Lukas Schramm (Dabendorf Orthodox Religion) on 16-07-16.
//
//

func slowSort(_ i: Int, _ j: Int, _ numberList: inout [Int]) {
  guard if i < j else { return }
  let m = (i+j)/2
  slowsort(i, m, &numberList)
  slowsort(m+1, j, &numberList)
  if numberList[j] < numberList[m] {
    let temp = numberList[j]
    numberList[j] = numberList[m]
    numberList[m] = temp
  }
  slowsort(i, j-1, &numberList)
}
