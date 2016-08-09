//: Playground - noun: a place where people can play

func insertionSort<T>(inout array: [T], _ isOrderedBefore: (T, T) -> Bool) {
    guard array.count > 1 else { return }
    
    for x in 1..<array.count {
        var y = x
        let temp = array[y]
        while y > 0 && isOrderedBefore(temp, array[y - 1]) {
            array[y] = array[y - 1]
            y -= 1
        }
        array[y] = temp
    }
}

var list = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
insertionSort(&list, <)
insertionSort(&list, >)
