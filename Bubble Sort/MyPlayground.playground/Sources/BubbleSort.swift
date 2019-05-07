//
//  BubbleSort.swift
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

/// Performs the bubble sort algorithm in the array
///
/// - Parameter elements: a array of elements that implement the Comparable protocol
/// - Returns: an array with the same elements but in order
public func bubbleSort<T> (_ elements: [T]) -> [T] where T: Comparable {
  return bubbleSort(elements, <)
}

public func bubbleSort<T> (_ elements: [T], _ comparison: (T,T) -> Bool) -> [T]  {
  var array = elements
  
  for i in 0..<array.count {
    for j in 1..<array.count-i {
      if comparison(array[j], array[j-1]) {
        let tmp = array[j-1]
        array[j-1] = array[j]
        array[j] = tmp
      }
    }
  }
  
  return array
}
