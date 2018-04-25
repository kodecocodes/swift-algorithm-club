# IntroSort

Goal: Sort an array from low to high (or high to low).

IntroSort is the algorithm used by swift to sort a collection. Introsort is an hybrid algorithm invented by David Musser  in 1993 with the purpose of giving a generic sorting algorithm for the C++ standard library. The classic implementation of introsort expect a recursive Quicksort with fallback to Heapsort in case the recursion depth level reached a certain max. The maximum depends on the number of elements in the collection and it is usually 2 * log(n). The reason behind this “fallback” is that if Quicksort was not able to get the solution after 2 * log(n) recursions for a branch, probably it hit its worst case and it is degrading to complexity O( n^2 ). To optimise even further this algorithm, the swift implementation introduce an extra step in each recursion where the partition is sorted using InsertionSort if the count of the partition is less than 20.

The number 20 is an empiric number obtained observing the behaviour of InsertionSort with lists of this size.

Here's an implementation in pseudocode:

```
procedure sort(A : array):
    let maxdepth = ⌊log(length(A))⌋ × 2
    introSort(A, maxdepth)

procedure introsort(A, maxdepth):
    n ← length(A)
    if n < 20:
        insertionsort(A)
    else if maxdepth = 0:
        heapsort(A)
    else:
        p ← partition(A)  // the pivot is selected using median of 3
        introsort(A[0:p], maxdepth - 1)
        introsort(A[p+1:n], maxdepth - 1)
```

## An example

Let's walk through the example. The array is initially:

	[ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]


For this example let's assume that `maxDepth` is **2** and that the size of the partition for the insertionSort to kick in is **5**

The first iteration of introsort begins by attempting to use insertionSort. The collection has 13 elements, so it tries to do heapsort instead. The condition for heapsort to occur is if `maxdepth == 0` evaluates true. Since `maxdepth` is currently **2** for the first iteration, introsort will default to quicksort.

The `partition`  method picks the first element, the median and the last, it sorts them and uses the new median as pivot.

    [ 10, 8, 26 ] -> [ 8, 10, 26 ]
    
Our array is now

    [ 8, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, -1, 26 ]

**10** is the pivot. After the choice of the pivot, the `partition` method swaps elements to get all the elements less than pivot on the left, and all the elements more or equal than pivot on the right.

    [ 8, 0, 3, 9, 2, 1, 5, 8, -1, 10, 27, 14, 26 ]
    
Because of the swaps, the index of of pivot is now changed and returned. The next step of introsort is to call recursively itself for the two sub arrays:

    less: [ 8, 0, 3, 9, 2, 1, 5, 8, -1, 10 ]
    greater: [ 27, 14, 26 ]

## maxDepth: 1, branch: less

    [ 8, 0, 3, 9, 2, 1, 5, 8, -1, 10 ]

The count of the array is still more than 5 so we don't meet yet the conditions for insertion sort to kick in. At this iteration maxDepth is decreased by one but it is still more than zero, so heapsort will not act.

Just like in the previous iteration quicksort wins and the `partition` method choses a pivot and sorts the elemets less than pivot on the left and the elements more or equeal than pivot on the right.

    array: [ 8, 0, 3, 9, 2, 1, 5, 8, -1, 10 ]
    pivot candidates: [ 8, 1, 10] -> [ 1, 8, 10]
    pivot: 8
    before partition: [ 1, 0, 3, 9, 2, 8, 5, 8, -1, 10 ]
    after partition: [ 1, 0, 3, -1, 2, 5, 8, 8, 9, 10 ]
    
    less: [ 1, 0, 3, -1, 2, 5, 8 ]
    greater: [ 8, 9, 10 ]
    
## maxDepth: 0, branch: less

    [ 1, 0, 3, -1, 2, 5, 8 ]
    
Just like before, introsort is recursively executed for `less` and greater. This time `less`has a count more than **5** so it will not be sorted with insertion sort, but the maxDepth decreased again by 1 is now 0 and heapsort takes over sorting the array.

    heapsort -> [ -1, 0, 1, 2, 3, 5, 8 ]
    
## maxDepth: 0, branch: greater

    [ 8, 9, 10 ]

following greater in this recursion, the count of elements is 3, which is less than 5, so this partition is sorted using insertionSort.

    insertionSort -> [ 8, 9 , 10]
    

## back to maxDepth = 1, branch: greater

    [ 27, 14, 26 ]

At this point the original array has mutated to be

    [ -1, 0, 1, 2, 3, 5, 8, 8, 9, 10, 27, 14, 26 ]
    
now the `less` partition is sorted  and since the count of the `greater` partition is 3 it will be sorted with insertion sort  `[ 14, 26, 27 ]`

The array is now successfully sorted

    [ -1, 0, 1, 2, 3, 5, 8, 8, 9, 10, 14, 26, 27 ]


## See also

[Introsort on Wikipedia](https://en.wikipedia.org/wiki/Introsort)
[Introsort comparison with other sorting algorithms](http://agostini.tech/2017/12/18/swift-sorting-algorithm/)
[Introsort implementation from the Swift standard library](https://github.com/apple/swift/blob/09f77ff58d250f5d62855ea359fc304f40b531df/stdlib/public/core/Sort.swift.gyb)

*Written for Swift Algorithm Club by Giuseppe Lanza*
