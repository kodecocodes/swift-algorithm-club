import Foundation

public func BubbleSort<T> (_ elements: [T]) -> [T] where T: Comparable {
    var array = elements
    
    for i in 0..<array.count {
        for j in i+1..<array.count {
            if array[j] < array[i] {
                let tmp = array[i]
                array[i] = array[j]
                array[j] = tmp
            }
        }
    }
    
    return array
}


var array = [Int]()

for _ in 0...10 {
    array.append(Int.random(in: 0...500))
}

print("before:",array)
print("after:",BubbleSort(array))
