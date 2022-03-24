//
//  StalinSort.swift
//
//  Created by Julio Brazil on 1/10/18.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
//  EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
//  AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
//  OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

/// This is a joke sorting algorithm proposed on social media to poke fun at dictatorial regimes, it excludes elements considered not in order based on the first element.
/// - Parameters:
///   - elements: The array containing the elements that are to be "sorted" by the algorithm.
/// - Returns: The new array containing the same amount or fewer elements than provided, but guaranteed to be in order.
public func stalinSort<T: Comparable>(_ originalArray: [T]) -> [T] {
    return stalinSort(originalArray, >)
}

/// This is a joke sorting algorithm proposed on social media to poke fun at dictatorial regimes, it excludes elements considered not in order based on the first element.
/// - Parameters:
///   - elements: The array containing the elements that are to be "sorted" by the algorithm.
///   - isInOrder: A function that takes 2 comparable inputs and returns if the elements provided are considered "in order".
/// - Returns: The new array containing the same amount or fewer elements than provided, but guaranteed to be in order.
public func stalinSort<T: Comparable>(_ elements: [T], _ isInOrder: (T, T) -> Bool) -> [T] {
    var index = 1
    var array = elements
    
    while index < array.count {
        let current = array[index]
        let previous = array[index-1]
        
        if isInOrder(previous, current) {
            index += 1
        } else {
            array.remove(at: index)
        }
    }
    
    return array
}
