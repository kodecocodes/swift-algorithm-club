# Bit Manipulation

## Find Unique Number

You are given an array of integers where every element except one appears twice. Find the unique number.

### Solution 1

Iterate through the array and compare each number with the rest of the array to check for uniqueness:

```swift
for i in 0..<a.count {
    var count = 0
    for j in 0..<a.count {
        if a[i] == a[j] {
            count += 1
        }
    }
    if count == 1 {
        return a[i]
    }
}
```

Time complexity for this solution is `O(n^2)` 

### Solution 2

A hash table (aka dictionary) can be used to keep track of the # of occurrences of each number. Each key in the dictionary represents a number, and the value of each key will be the # of occurences. This is similar to counting sort, and uses the same methodology as the ![Multiset](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Multiset).


```swift
var count: [Int: Int] = [:]
for key in a {
	guard let c = count[key] else {
      count[key] = 1
      continue
	}
	count[key] = c + 1
}

for (key, val) in count {
	if val == 1 {
      return key
	}
}
```

The time complexity of this solution is `O(n)`. Since you've had to use an hashmap as an intermediate store for this algorithm, there's also a space complexity of `O(n)`.

### Solution 3

You can also make use of the **XOR** logical gate. Here's a quick review in case you've forgot how XOR works:

```swift
0 ^ 0 = 0

0 ^ 1 = 1

1 ^ 0 = 1

1 ^ 1 = 0
```

The first condition is of particular interest. That means `a ^ a = 0`

That's exactly what we want, right?

Here is the code

```swift
var ret = 0
for num in a {
	ret = ret ^ num
}
        
return ret
```

## Find Unique Number 2

You're given an array where each value appears 3 times, except for one value which appears once. Return the unique value.

### Solution

How about we do `XOR` for all elements ? like `a ^ a ^ a ^ b ^ b ^ b ^ c = a ^ b ^ c`.

But the result is just every elements `XOR`. How we remove `a` and `b` then get `c`. Hmm, not easy.

How about `AND`. We need to calculate each bit count for all numbers, them `count % 3 == 1` means that bit the number appears once occupy it. Why?

And we maintain a result number that `OR` all bits and get the result.

```swift
var ret = 0
for i in 0..<32 {
	let mask = 1 << i
	var sum = 0
	for num in a {
		if num & mask != 0 {
			sum += 1
		}
	}
            
	if sum % 3 == 1 {
		ret = ret | mask
	}
}
        
return ret
```




## Find Unique Number 3

Follow up - Every element appears twice, but 2 elements appear only once. How to find these 2 numbers?

### Solution

Use `XOR`  , we get something like this `a ^ a ^ b ^ b ^ c ^ d = c ^ d`

But how we split `c` and `d` ?

We can reuse the previous problem idea. We count the first bit that `c` and `d` are different. Then split the numbers into 2 groups. 

`c` will be in group 1, and `d` will be in group 2. Then we get the result.

Here is the code.

```swift
var ret = 0
for num in a {
	ret = ret ^ num
}
        
var mask = 1
while (true) {
	if mask & ret != 0 {
		break
	}
	mask <<= 1
}
        
var num1 = 0
var num2 = 0
        
for num in a {
	if num & mask == 0 {
		num1 = num1 ^ num
	} else {
		num2 = num2 ^ num
	}
}
        
return (num1, num2)
```




