import Foundation

public func BubbleSort<T> (_ elements: [T]) -> [T] where T: Comparable {
    var array = elements
    
    for i in 0..<array.count {
        for j in 1..<array.count-i {
            print(array,"comparing [\(j-1)] with [\(j)]")
            if array[j] < array[j-1] {
                let tmp = array[j-1]
                array[j-1] = array[j]
                array[j] = tmp
            }
        }
    }
    
    return array
}

var array = [4,2,1,3]

print("before:",array)
print("after:",BubbleSort(array))
