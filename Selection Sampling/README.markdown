# Selection Sampling

Goal: Select *k* items at random from a collection of *n* items.

Let's say you have a deck of 52 playing cards and you need to draw 10 cards at random. This algorithm lets you do that.

Here's a very fast version:

```swift
func select<T>(from a: [T], count k: Int) -> [T] {
  var a = a
  for i in 0..<k {
    let r = random(min: i, max: a.count - 1)
    if i != r {
      swap(&a[i], &a[r])
    }
  }
  return Array(a[0..<k])
}
```

As often happens with these [kinds of algorithms](../Shuffle/), it divides the array into two regions. The first region contains the selected items; the second region is all the remaining items.

Here's an example. Let's say the array is:

	[ "a", "b", "c", "d", "e", "f", "g" ]
	
We want to select 3 items, so `k = 3`. In the loop, `i` is initially 0, so it points at `"a"`.

	[ "a", "b", "c", "d", "e", "f", "g" ]
	   i

We calculate a random number between `i` and `a.count`, the size of the array. Let's say this is 4. Now we swap `"a"` with `"e"`, the element at index 4, and move `i` forward:

	[ "e" | "b", "c", "d", "a", "f", "g" ]
	         i

The `|` bar shows the split between the two regions. `"e"` is the first element we've selected. Everything to the right of the bar we still need to look at.

Again, we ask for a random number between `i` and `a.count`, but because `i` has shifted, the random number can never be less than 1. So we'll never again swap `"e"` with anything.

Let's say the random number is 6 and we swap `"b"` with `"g"`:

	[ "e" , "g" | "c", "d", "a", "f", "b" ]
	               i

One more random number to pick, let's say it is 4 again. We swap `"c"` with `"a"` to get the final selection on the left:

	[ "e", "g", "a" | "d", "c", "f", "b" ]

And that's it. Easy peasy. The performance of this function is **O(k)** because as soon as we've selected *k* elements, we're done.

Here is an alternative algorithm, called "reservoir sampling":

```swift
func reservoirSample<T>(from a: [T], count k: Int) -> [T] {
  precondition(a.count >= k)

  var result = [T]()      // 1
  for i in 0..<k {
    result.append(a[i])
  }

  for i in k..<a.count {  // 2
    let j = random(min: 0, max: i)
    if j < k {
      result[j] = a[i]
    }
  }
  return result
}
```

This works in two steps:

1. Fill the `result` array with the first `k` elements from the original array. This is called the "reservoir".
2. Randomly replace elements in the reservoir with elements from the remaining pool.

The performance of this algorithm is **O(n)**, so it's a little bit slower than the first algorithm. However, its big advantage is that it can be used for arrays that are too large to fit in memory, even if you don't know what the size of the array is (in Swift this might be something like a lazy generator that reads the elements from a file).

There is one downside to the previous two algorithms: they do not keep the elements in the original order. In the input array `"a"` came before `"e"` but now it's the other way around. If that is an issue for your app, you can't use this particular method.

Here is an alternative approach that does keep the original order intact, but is a little more involved:

```swift
func select<T>(from a: [T], count requested: Int) -> [T] {
  var examined = 0
  var selected = 0
  var b = [T]()
  
  while selected < requested {                          // 1
    let r = Double(arc4random()) / 0x100000000          // 2
    
    let leftToExamine = a.count - examined              // 3
    let leftToAdd = requested - selected

    if Double(leftToExamine) * r < Double(leftToAdd) {  // 4
      selected += 1
      b.append(a[examined])
    }

    examined += 1
  }
  return b
}
```

This algorithm uses probability to decide whether to include a number in the selection or not. 

1. The loop steps through the array from beginning to end. It keeps going until we've selected *k* items from our set of *n*. Here, *k* is called `requested` and *n* is `a.count`.

2. Calculate a random number between 0 and 1. We want `0.0 <= r < 1.0`. The higher bound is exclusive; we never want it to be exactly 1. That's why we divide the result from `arc4random()` by `0x100000000` instead of the more usual `0xffffffff`.

3. `leftToExamine` is how many items we still haven't looked at. `leftToAdd` is how many items we still need to select before we're done.

4. This is where the magic happens. Basically, we're flipping a coin. If it was heads, we add the current array element to the selection; if it was tails, we skip it.

Interestingly enough, even though we use probability, this approach always guarantees that we end up with exactly *k* items in the output array.

Let's walk through the same example again. The input array is:

	[ "a", "b", "c", "d", "e", "f", "g" ]

The loop looks at each element in turn, so we start at `"a"`. We get a random number between 0 and 1, let's say it is 0.841. The formula at `// 4` multiplies the number of items left to examine with this random number. There are still 7 elements left to examine, so the result is: 

	7 * 0.841 = 5.887

We compare this to 3 because we wanted to select 3 items. Since 5.887 is greater than 3, we skip `"a"` and move on to `"b"`.

Again, we get a random number, let's say 0.212. Now there are only 6 elements left to examine, so the formula gives:

	6 * 0.212 = 1.272

This *is* less than 3 and we add `"b"` to the selection. This is the first item we've selected, so two left to go.

On to the next element, `"c"`. The random number is 0.264, giving the result:

	5 * 0.264 = 1.32

There are only 2 elements left to select, so this number must be less than 2. It is, and we also add `"c"` to the selection. The total selection is `[ "b", "c" ]`.

Only one item left to select but there are still 4 candidates to look at. Suppose the next random number is 0.718. The formula now gives:

	4 * 0.718 = 2.872

For this element to be selected the number has to be less than 1, as there is only 1 element left to be picked. It isn't, so we skip `"d"`. Only three possibilities left -- will we make it before we run out of elements?

The random number is 0.346. The formula gives:

	3 * 0.346 = 1.038
	
Just a tiny bit too high. We skip `"e"`. Only two candidates left...

Note that now literally we're dealing with a coin toss: if the random number is less than 0.5 we select `"f"` and we're done. If it's greater than 0.5, we go on to the final element. Let's say we get 0.583:

	2 * 0.583 = 1.166

We skip `"f"` and look at the very last element. Whatever random number we get here, it should always select `"g"` or we won't have selected enough elements and the algorithm doesn't work!

Let's say our final random number is 0.999 (remember, it can never be 1.0 or higher). Actually, no matter what we choose here, the formula will always give a value less than 1:

	1 * 0.999 = 0.999

And so the last element will always be chosen if we didn't have a big enough selection yet. The final selection is `[ "b", "c", "g" ]`. Notice that the elements are still in their original order, because we examined the array from left to right.

Maybe you're not convinced yet... What if we always got 0.999 as the random value (the maximum possible), would that still select 3 items? Well, let's do the math:

	7 * 0.999 = 6.993     is this less than 3? no
	6 * 0.999 = 5.994     is this less than 3? no
	5 * 0.999 = 4.995     is this less than 3? no
	4 * 0.999 = 3.996     is this less than 3? no
	3 * 0.999 = 2.997     is this less than 3? YES
	2 * 0.999 = 1.998     is this less than 2? YES
	1 * 0.999 = 0.999     is this less than 1? YES

It always works! But does this mean that elements closer to the end of the array have a higher probability of being chosen than those in the beginning? Nope, all elements are equally likely to be selected. (Don't take my word for it: see the playground for a quick test that shows this in practice.)

Here's an example of how to test this algorithm:

```swift
let input = [
  "there", "once", "was", "a", "man", "from", "nantucket",
  "who", "kept", "all", "of", "his", "cash", "in", "a", "bucket",
  "his", "daughter", "named", "nan",
  "ran", "off", "with", "a", "man",
  "and", "as", "for", "the", "bucket", "nan", "took", "it",
]

let output = select(from: input, count: 10)
print(output)
print(output.count)
```

The performance of this second algorithm is **O(n)** as it may require a pass through the entire input array.

> **Note:** If `k > n/2`, then it's more efficient to do it the other way around and choose `a.count - k` items to remove.

Based on code from Algorithm Alley, Dr. Dobb's Magazine, October 1993.

*Written for Swift Algorithm Club by Matthijs Hollemans*
