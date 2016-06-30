# Bubble Sort*

Goal: To sort an array from the lowest to highest value (or highest to lowest).

You are given an array of unsorted values. The BubbleSort algorithm works as follows:

```swift
   for in j = 0; j < array.count; j++ 
      {
         for in i = 0; 0 < array.count - 1; i++ 
         {
            
               if current > array[i + 1] 
               {
                  swap(&array[i], &array[j])
               }
            
         }
      }
```
This code can be tested with the following:
```swift
in test: [Int] = [3, 2, 9, 6, 5]
bubbleSort(test)
```
Here is how it works.

Bubble Sort compares each adjacent pair of values and swaps said values if they are not in the correct order. This process is repeated until there are no additonal swaps required. This indicates that the sorting process is complete. Given the simple nature of this algorithm, it is excruciatingly slow and thus impractical for implementation. In some rare cases it can be practical; the best case scenario being O(n).

Step by Step example using the test code provided above:

Initial Pass
- {3,2,9,6,5} -> {2,3,9,6,5} // 2 is less than 3 so they are swapped
- {2,3,9,6,5} -> {2,3,9,6,5} // 3 is less than 9 so they are not swapped
- {2,3,9,6,5} -> {2,3,6,9,5} // 6 is less than 9 so they are swapped
- {2,3,6,9,5} -> {2,3,6,5,9} // 5 is less than 9 so they are swapped

Second Pass
- {2,3,6,5,9} -> {2,3,6,5,9} // 2 is less than 3 so they are not swapped
- {2,3,6,5,9} -> {2,3,6,5,9} // 3 is less than 6 so they are not swapped
- {2,3,6,5,9} -> {2,3,5,6,9} // 5 is less than 6 so they are swapped
- {2,3,5,6,9} -> {2,3,5,6,9} // 6 is less than 9 so they are not swapped

This algorithm can be optimized by checking if the list is sorted after each iteration. If it's already sorted, there is no need for additional iterations through the array provided. This can be possible through the implementation of a flag variable(false) that becmes true once any swaps are made through an iteration.


**This is a horrible algorithm. There is no reason why you should have to know it.

