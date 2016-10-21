# Slow Sort

Goal: Sort an array of numbers from low to high (or high to low).

You are given an array of numbers and need to put them in the right order. The insertion sort algorithm works as follows:

We can decompose the problem of sorting n numbers in ascending order into

1. find the maximum of the numbers
 1. find the maximum of the first n/2 elements
 2. find the maximum of the remaining n/2 elements
 3. find the largest of those two maxima
2. sorting the remaining ones

## The code

Here is an implementation of slow sort in Swift:

```swift
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
```

## Performance

| Case  | Performance |
|:-------------: |:---------------:|
| Worst       |  slow |
| Best      | 	O(n^(log(n)/(2+e))))        |
|  Average | 	O(n^(log(n)/2))       | 

## See also

[Slow Sort explanation in the Internet](http://c2.com/cgi/wiki?SlowSort)

*Written for Swift Algorithm Club by Lukas Schramm*

(used the Insertion Sort Readme as template)