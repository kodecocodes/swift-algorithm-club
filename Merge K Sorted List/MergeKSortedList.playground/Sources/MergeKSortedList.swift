//
//  MergeKSortedList.swift
//  
//
//  Created by Kai Chen on 29/07/2017.
//
//

import Foundation

public class MergeKSortedList<T: Comparable> {

    public init() {}

    public func mergeLists(_ lists: [LinkedList<T>?]) -> LinkedList<T>? {
        var l = lists

        return mergeSort(&l, beg: 0, end: l.count - 1)
    }

    private func mergeSort(_ list: inout [LinkedList<T>?], beg: Int, end: Int) -> LinkedList<T>? {
        if beg > end {
            return nil
        }

        if beg == end {
            return list[beg]
        }

        let mid = beg + (end - beg) / 2

        let left = mergeSort(&list, beg: beg, end: mid)
        let right = mergeSort(&list, beg: mid + 1, end: end)

        guard let leftList = left else {
            return right
        }

        guard let rightList = right else {
            return left
        }

        let newList = LinkedList<T>()

        while !leftList.isEmpty && !rightList.isEmpty {
            guard let leftVal = leftList.first?.value,
                let rightVal = rightList.first?.value else {
                break
            }

            if leftVal <= rightVal {
                newList.append(leftVal)
                leftList.remove(atIndex: 0)
            } else {
                newList.append(rightVal)
                rightList.remove(atIndex: 0)
            }
        }

        if !leftList.isEmpty {
            newList.append(leftList)
        }

        if !rightList.isEmpty {
            newList.append(rightList)
        }

        return newList
    }
}
