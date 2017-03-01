//
//  SlowSort.swift
//  
//
//  Created by Pope Lukas Schramm (Dabendorf Orthodox Religion) on 16-07-16.
//
//

var numberList = [1,12,9,17,13,12]

public func slowsort(_ i: Int, _ j: Int) {
    if i>=j {
        return
    }
    let m = (i+j)/2
    slowsort(i,m)
    slowsort(m+1,j)
    if numberList[j] < numberList[m] {
        let temp = numberList[j]
        numberList[j] = numberList[m]
        numberList[m] = temp
    }
    slowsort(i,j-1)
}


slowsort(0,numberList.count-1)
print(numberList)
