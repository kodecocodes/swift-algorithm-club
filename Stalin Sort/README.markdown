# Stalin Sort

Stalin sort is a joke algorithm [proposed on social media](https://mastodon.social/@mathew/100958177234287431) poking fun at dictatorial regimes. Even though it has no use as a sorting algorithm, it is a valid logic exercise.

##### Runtime:
- Average: O(n)
- Worst: O(n)

##### Memory:
- O(1)

### Implementation:

The implementation will not be shown as, you know, it's not usefull for sorting things. However, having a grasp of the concept will help you understand the basics of simple sorting algorithms.

Stalin sort is a very simple sorting algorithm, it consists in comparing elements in the array with the previous one, if the element you are comparing is not considered "in order" it is removed from the array and the next one is comparade, until you either run out of elements or reach the end of the array. The easiest way of implementing this would be with an While Loop, since we are do not know how many elements will be taken out and what size will the array be at the end.

#### Example
We begin analyzing the array by the secong element, since the first one will always be in order (the first element is the reference for the rest of the array). Comparing a given element with the previous one, if they are considered ordered, the element is kept in the array and a counter is increased, indicating the index of the next element to be analysed.
Let's take the array `[5, 1, 8, 2, 4]`, and sort the array from lowest number to greatest number using Stalin sort. 

##### First Pass
[ 5 **1** 8 2 4 ] -> [ 5 8 2 4 ], Here, the algorithm compares the second element (of value **1**) with the previous (of value 5),  and romeves it, since 5 > 1.

##### Scont Pass
[ 5 **8** 2 4 ] -> [ 5 **8** 2 4 ], This time the situation is different, since 8 > 5, the element is considered to be in order, so it is left alone.

##### Third Pass
[ 5 8 **2** 4 ] -> [ 5 8 4 ], i believe you are getting the hang of it, 8 > 2, and since we are ordering from lowest to gratest number, 2 is considered "out of order" and is forcibly removed from the group.

#### Code
```swift
var index = 1

while index < array.count {
    let current = array[index]
    let previous = array[index-1]
    
    if previous > current {
        index += 1
    } else {
        array.remove(at: index)
    }
}
```

The code presented in this repository is different, to allow grater flexibility and reusability, not that you should use it, specially if your intent is to order an array, as a matter of fact, let me be even clearer...

#### Conclusion

# DO NOT USE THIS ALGORITHM TO ORDER AN ARRAY

This sorting algorithm is a joke and should be trated as one, it is only described here because it has **some** value as an teaching resource.

*Created for the Swift Algorithm Club by [Julio Brazil](https://github.com/JulioBBL)*

##### Supporting Links
[Original post by Mathew @mastodon.social](https://mastodon.social/@mathew/100958177234287431)
