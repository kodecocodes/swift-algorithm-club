# Mergesort

Goal: Sort an array from low to high (or high to low)

Invented in 1945, mergesort is a fairly efficient sorting algorithm with a best, worst, and average time complexity of **O(n log n)**. The idea behind Mergesort
is to **divide and conquer**; To divide a big problem into smaller chunks and solving many small problems instead of solving a big one. I think of mergesort as **split first** and **merge after**. Assume you're given an array of *n* numbers and you need to put them in the right order. The merge sort algorithm works as follows:

- Put the numbers in a pile. The pile is unsorted.
- Split the pile into 2. Now you have **two unsorted piles** of numbers.
- Keep splitting the resulting piles until you can't anymore; In the end, you will have *n* piles with 1 number in each pile
- Begin to **merge** the piles together by sequentially pairing a pile with another pile. During each merge, you want to sort the contents in order

## An example

### Splitting

Let's say the numbers to sort are `[2, 1, 5 , 4, 9]`. This is your unsorted pile. Our goal is to keep splitting the pile until you can't anymore. 

Split the array into two halves - `[2, 1,]` and `[5, 4, 9]`. Can you keep splitting them? Yes you can!

Focus on the left pile. `[2, 1]` will split into `[2]` and `[1]`. Can you keep splitting them? No. Time to check the other pile.

`[5, 4, 9]` splits to `[5]` and `[4, 9]`. Unsurprisingly, `[5]` can't split into anymore, but `[4, 9]` splits into `[4]` and `[9]`. 

The splitting process ends with the following piles:

`[2]` `[1]` `[5]` `[4]` `[9]`

### Merging

Now that you've split the array, you'll **merge** the piles together **while sorting them**. Remember, the idea is to solve many small problems rather than a big one. For each merge iteration you'll only be concerned at merging one pile with another.

Given `[2]` `[1]` `[5]` `[4]` `[9]`, the first pass will result in `[1, 2]` and `[4, 5]` and `[9]`. Since `[9]` is the odd one out, you can't merge it with anything during this pass. 

The next pass will merge `[1, 2]` and `[4, 5]` together. This results in `[1, 2, 4, 5]`, with the `[9]` left out again since it's the odd one out. 

Since you're left with 2 piles, `[9]` finally gets it's chance to merge, resulting in the sorted array `[1, 2, 4, 5, 9]`. 

In code, it looks like this:

```swift
let array = [2, 1, 5, 4, 9]

func mergeSort(array: [Int]) -> [Int] {

  // base case - if the unsortedArray has less than 2 elements - aka 1 element, simply return, no need to split further
  if array.count < 2 { return array }
  let middleIndex = array.count / 2

  // recursively split the left side of the array
  let leftArray = mergeSort(Array(array[0..<middleIndex]))

  // recursively split the right side of the array
  let rightArray = mergeSort(Array(array[middleIndex..<array.count]))

  // at this point, you should have n piles of arrays with a single element. Time to merge
  return merge(leftPile: leftArray, rightPile: rightArray)
}

func merge(leftPile leftPile: [Int], rightPile: [Int]) -> [Int] {
  var leftIndex = 0
  var rightIndex = 0

  // orderedPile will be the result of the merge
  var orderedPile = [Int]()

  // insert
  while leftIndex < leftPile.count && rightIndex < rightPile.count {
    if leftPile[leftIndex] < rightPile[rightIndex] {
      orderedPile.append(leftPile[leftIndex])
      leftIndex += 1
    } else if leftPile[leftIndex] > rightPile[rightIndex] {
      orderedPile.append(rightPile[rightIndex])
      rightIndex += 1
    } else {
      orderedPile.append(leftPile[leftIndex])
      leftIndex += 1
      orderedPile.append(rightPile[rightIndex])
      rightIndex += 1
    }
  }

  while leftIndex < leftPile.count {
    orderedPile.append(leftPile[leftIndex])
    leftIndex += 1
  }

  while rightIndex < rightPile.count {
    orderedPile.append(rightPile[rightIndex])
    rightIndex += 1
  }

  return orderedPile
}
```