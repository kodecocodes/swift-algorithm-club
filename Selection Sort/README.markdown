# Selection Sort

Goal: Sort an array from low to high (or high to low).

You are given an array of numbers and need to put them in the right order. The selection sort algorithm divides the array into two parts: the beginning of the array is sorted, while the rest of the array consists of the numbers that still remain to be sorted. 

	[ ...sorted numbers... | ...unsorted numbers... ]

This is similar to [insertion sort](../Insertion Sort/), but the difference is in how new numbers are added to the sorted portion.

It works as follows:

- Find the lowest number in the array. You start at index 0, loop through all the numbers in the array, and keep track of what the lowest number is.
- Swap the lowest number you've found with the number at index 0. Now the sorted portion consists of just the number at index 0.
- Go to index 1.
- Find the lowest number in the rest of the array. This time you start looking from index 1. Again you loop until the end of the array and keep track of the lowest number you come across.
- Swap it with the number at index 1. Now the sorted portion contains two numbers and extends from index 0 to index 1.
- Go to index 2.
- Find the lowest number in the rest of the array, starting from index 2, and swap it with the one at index 2. Now the array is sorted from index 0 to 2; this range contains the three lowest numbers in the array.
- And so on... until no numbers remain to be sorted.

It's called a "selection" sort, because at every step you search through the rest of the array to select the next lowest number.

## An example

Let's say the numbers to sort are `[ 5, 8, 3, 4, 6 ]`. We also keep track of where the sorted portion of the array ends, denoted by the `|` symbol. 

Initially, the sorted portion is empty:

	[| 5, 8, 3, 4, 6 ]

Now we find the lowest number in the array. We do that by scanning through the array from left to right, starting at the `|` bar. We find the number `3`.

To put this number into the sorted position, we swap it with the number next to the `|`, which is `5`:

	[ 3 | 8, 5, 4, 6 ]
	  *      *

The sorted portion is now `[ 3 ]` and the rest is `[ 8, 5, 4, 6 ]`.

Again, we look for the lowest number, starting from the `|` bar. We find `4` and swap it with `8` to get:

	[ 3, 4 | 5, 8, 6 ]
	     *      *

With every step, the `|` bar moves one position to the right. We again look through the rest of the array and find `5` as the lowest number. There's no need to swap `5` with itself and we simply move forward:

	[ 3, 4, 5 | 8, 6 ]
	        *

This process repeats until the array is sorted. Note that everything to the left of the `|` bar is always in sorted order and always contains the lowest numbers in the array. Finally, we end up with:

	[ 3, 4, 5, 6, 8 |]

As you can see, selection sort is an *in-place* sort because everything happens in the same array; no additional memory is necessary. You can also implement this as a *stable* sort so that identical elements do not get swapped around relative to each other (note that the version given below isn't stable).

## The code

Here is an implementation of selection sort in Swift:

```swift
func selectionSort(_ array: [Int]) -> [Int] {
  guard array.count > 1 else { return array }  // 1

  var a = array                    // 2

  for x in 0 ..< a.count - 1 {     // 3
    
    var lowest = x
    for y in x + 1 ..< a.count {   // 4
      if a[y] < a[lowest] {
        lowest = y
      }
    }
    
    if x != lowest {               // 5
      swap(&a[x], &a[lowest])
    }
  }
  return a
}
```

Put this code in a playground and test it like so:

```swift
let list = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
selectionSort(list)
```

A step-by-step explanation of how the code works:

1. If the array is empty or only contains a single element, then there's not much point to sorting it.

2. Make a copy of the array. This is necessary because we cannot modify the contents of the `array` parameter directly in Swift. Like Swift's own `sort()`, the `selectionSort()` function will return a sorted *copy* of the original array.

3. There are two loops inside this function. The outer loop looks at each of the elements in the array in turn; this is what moves the `|` bar forward.

4. This is the inner loop. It finds the lowest number in the rest of the array.

5. Swap the lowest number with the current array index. The `if` check is necessary because you can't `swap()` an element with itself in Swift.

In summary: For each element of the array, selection sort swaps positions with the lowest value from the rest of the array. As a result, the array gets sorted from the left to the right. (You can also do it right-to-left, in which case you always look for the largest number in the array. Give that a try!)

> **Note:** The outer loop ends at index `a.count - 2`. The very last element will automatically always be in the correct position because at that point there are no other smaller elements left.

The source file [SelectionSort.swift](SelectionSort.swift) has a version of this function that uses generics, so you can also use it to sort strings and other types.

## Performance

Selection sort is easy to understand but it performs quite badly, **O(n^2)**. It's worse than [insertion sort](../Insertion Sort/) but better than [bubble sort](../Bubble Sort/). The killer is  finding the lowest element in the rest of the array. This takes up a lot of time, especially since the inner loop will be performed over and over.

[Heap sort](../Heap Sort/) uses the same principle as selection sort but has a really fast method for finding the minimum value in the rest of the array. Its performance is **O(n log n)**.

## See also

[Selection sort on Wikipedia](https://en.wikipedia.org/wiki/Selection_sort)

*Written for Swift Algorithm Club by Matthijs Hollemans*
