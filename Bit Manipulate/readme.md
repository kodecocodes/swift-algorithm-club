# Bit Manipulation

## Find Unique Number

Given an array of Int, every element appears twice, only one number appears once. We need to find that unique number.

### Solution 1

We can enumerate the number and then check if this number appears exactly once. Here is the code

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

Time complexity will be `O(n^2)` 

### Solution 2

Dig deep into Solution 1, we can find that we did a lot of duplicate calculation to count the number apperance. Could we avoid the duplicate count? How about we find a way to store the number appearance? Like hash table? Then we can loop all elements in the hash table, if the count is 1, that's the number we want.

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

In this algorithm, we reduce the time complexity to `O(n)`

### Solution 3

In Solution 2, the time complexity is the best already. But it still needs `O(n)` extra space. Is there a way to reduce `O(n)` space to `O(1)` ?

The answer is : YES! 

How? Bit manipulation.

Do you still remember `XOR` operation? How it works?

Here is a quick review for you.

```swift
0 ^ 0 = 0

0 ^ 1 = 1

1 ^ 0 = 1

1 ^ 1 = 0
```

So, the most important idea here is if two numbers are the same, their result is 0. That means `a ^ a = 0`

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

Follow up - If every element appears 3 times, and only one number appears once. How to solve it?

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




