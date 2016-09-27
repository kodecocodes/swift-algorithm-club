# Counting Sort

Counting sort is an algorithm for sorting a collection of objects according to keys that are small integers. It operates by counting the number of objects that have each distinct key values, and using arithmetic on those counts to determine the positions of each key value in the output sequence.

## Example

To understand the algorithm let's walk through a small example.

Consider the array: `[ 10, 9, 8, 7, 1, 2, 7, 3 ]`

### Step 1:

The first step is to count the total number of occurrences for each item in the array. The output for the first step would be a new array that looks as follows:

```
Index 0 1 2 3 4 5 6 7 8 9 10
Count 0 1 1 1 0 0 0 2 1 1 1
```

Here is the code to accomplish this:

```swift
  let maxElement = array.max() ?? 0

  var countArray = [Int](repeating: 0, count: Int(maxElement + 1))
  for element in array {
    countArray[element] += 1
  }
```

### Step 2:

In this step the algorithm tries to determine the number of elements that are placed before each element. Since, you already know the total occurrences for each element you can use this information to your advantage. The way it works is to sum up the previous counts and store them at each index.

The count array would be as follows:

```
Index 0 1 2 3 4 5 6 7 8 9 10
Count 0 1 2 3 3 3 3 5 6 7 8
```

The code for step 2 is:

```swift
  for index in 1 ..< countArray.count {
    let sum = countArray[index] + countArray[index - 1]
    countArray[index] = sum
  }
```

### Step 3:

This is the last step in the algorithm. Each element in the original array is placed at the position defined by the output of step 2. For example, the number 10 would be placed at an index of 7 in the output array. Also, as you place the elements you need to reduce the count by 1 as those many elements are reduced from the array.

The final output would be:

```
Index  0 1 2 3 4 5 6 7
Output 1 2 3 7 7 8 9 10
```

Here is the code for this final step:

```swift
  var sortedArray = [Int](repeating: 0, count: array.count)
  for element in array {
    countArray[element] -= 1
    sortedArray[countArray[element]] = element
  }
  return sortedArray
```

## Performance

The algorithm uses simple loops to sort a collection. Hence, the time to run the entire algorithm is **O(n+k)** where **O(n)** represents the loops that are required to initialize the output arrays and **O(k)** is the loop required to create the count array.

The algorithm uses arrays of length **n + 1** and **n**, so the total space required is **O(2n)**. Hence for collections where the keys are scattered in a dense area along the number line it can be space efficient.

*Written for Swift Algorithm Club by Ali Hafizji*
