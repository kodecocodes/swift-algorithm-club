/*

  Sorting Algorithm that sorts an input array of integers digit by digit.

*/


func radixSort(arr: inout [Int]) {
    let radix = 10

    var digit: Int = 1
    var largest: Int = 0

    var buckets: [[Int]]
    var index: Int
    var pos: Int

    repeat {
        pos = 0
        buckets = Array(repeatElement([], count: 10))

        for num in arr {
            index = num / digit
            buckets[index % radix].append(num)

            if digit == 1 {
                largest = max(largest, num)
            }
        }
        for bin in buckets {
            for num in bin {
                arr[pos] = num
                pos = pos + 1
            }
        }

        digit = digit * radix
    } while digit < largest
}
