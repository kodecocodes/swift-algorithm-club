//
//  RadixSortExample.swift
//  
//
//  Created by Cheer on 2017/3/2.
//
//

import Foundation

func radixSort1(_ arr: inout [Int]) {

    var temp = [[Int]](repeating: [], count: 10)

    for num in arr { temp[num % 10].append(num) }

    for i in 1...Int(arr.max()!.description.characters.count) {

        for index in 0..<temp.count {

            for num in temp[index] {
                temp[index].remove(at: temp[index].index(of: num)!)
                temp[(num / Int(pow(10, Double(i)))) % 10].append(num)
            }
        }
    }

    arr = temp[0]
}
