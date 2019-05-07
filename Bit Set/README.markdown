# Bit Set

A fixed-size sequence of *n* bits. Also known as bit array or bit vector.

To store whether something is true or false you use a `Bool`. Every programmer knows that... But what if you need to remember whether 10,000 things are true or not?

You could make an array of 10,000 booleans but you can also go hardcore and use 10,000 bits instead. That's a lot more compact because 10,000 bits fit in less than 160 `Int`s on a 64-bit CPU.

Since manipulating individual bits is a little tricky, you can use `BitSet` to hide the dirty work.

## The code

A bit set is simply a wrapper around an array. The array doesn't store individual bits but larger integers called the "words". The main job of `BitSet` is to map the bits to the right word.

```swift
public struct BitSet {
  private(set) public var size: Int

  private let N = 64
  public typealias Word = UInt64
  fileprivate(set) public var words: [Word]

  public init(size: Int) {
    precondition(size > 0)
    self.size = size

    // Round up the count to the next multiple of 64.
    let n = (size + (N-1)) / N
    words = [Word](repeating: 0, count: n)
  }
```

`N` is the bit size of the words. It is 64 because we store the bits in a list of unsigned 64-bit integers. (It's fairly easy to change `BitSet` to use 32-bit words instead.)

If you write,

```swift
var bits = BitSet(size: 140)
```

then the `BitSet` allocates an array of three words. Each word has 64 bits and therefore three words can hold 192 bits. We only use 140 of those bits so we're wasting a bit of space (but of course we can never use less than a whole word).

> **Note:** The first entry in the `words` array is the least-significant word, so these words are stored in little endian order in the array.

## Looking up the bits

Most of the operations on `BitSet` take the index of the bit as a parameter, so it's useful to have a way to find which word contains that bit.

```swift
  private func indexOf(_ i: Int) -> (Int, Word) {
    precondition(i >= 0)
    precondition(i < size)
    let o = i / N
    let m = Word(i - o*N)
    return (o, 1 << m)
  }
```

The `indexOf()` function returns the array index of the word, as well as a "mask" that shows exactly where the bit sits inside that word.

For example, `indexOf(2)` returns the tuple `(0, 4)` because bit 2 is in the first word (index 0). The mask is 4. In binary the mask looks like the following:

	0010000000000000000000000000000000000000000000000000000000000000

That 1 points at the second bit in the word.

> **Note:** Remember that everything is shown in little-endian order, including the bits themselves. Bit 0 is on the left, bit 63 on the right.

Another example: `indexOf(127)` returns the tuple `(1, 9223372036854775808)`. It is the last bit of the second word. The mask is:

	0000000000000000000000000000000000000000000000000000000000000001

Note that the mask is always 64 bits because we look at the data one word at a time.

## Setting and getting bits

Now that we know where to find a bit, setting it to 1 is easy:

```swift
  public mutating func set(_ i: Int) {
    let (j, m) = indexOf(i)
    words[j] |= m
  }
```

This looks up the word index and the mask, then performs a bitwise OR between that word and the mask. If the bit was 0 it becomes 1. If it was already set, then it remains set.

Clearing the bit -- i.e. changing it to 0 -- is just as easy:

```swift
  public mutating func clear(_ i: Int) {
    let (j, m) = indexOf(i)
    words[j] &= ~m
  }
```

Instead of a bitwise OR we now do a bitwise AND with the inverse of the mask. So if the mask was `00100000...0`, then the inverse is `11011111...1`. All the bits are 1, except for the bit we want to set to 0. Due to the way `&` works, this leaves all other bits alone and only changes that single bit to 0.

To see if a bit is set we also use the bitwise AND but without inverting:

```swift
  public func isSet(_ i: Int) -> Bool {
    let (j, m) = indexOf(i)
    return (words[j] & m) != 0
  }
```

We can add a subscript function to make this all very natural to express:

```swift
  public subscript(i: Int) -> Bool {
    get { return isSet(i) }
    set { if newValue { set(i) } else { clear(i) } }
  }
```

Now you can write things like:

```swift
var bits = BitSet(size: 140)
bits[2] = true
bits[99] = true
bits[128] = true
print(bits)
```

This will print the three words that the 140-bit `BitSet` uses to store everything:

```swift
0010000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000010000000000000000000000000000
1000000000000000000000000000000000000000000000000000000000000000
```

Something else that's fun to do with bits is flipping them. This changes 0 into 1 and 1 into 0. Here's `flip()`:

```swift
  public mutating func flip(_ i: Int) -> Bool {
    let (j, m) = indexOf(i)
    words[j] ^= m
    return (words[j] & m) != 0
  }
```

This uses the remaining bitwise operator, exclusive-OR, to do the flipping. The function also returns the new value of the bit.

## Ignoring the unused bits

A lot of the `BitSet` functions are quite easy to implement. For example, `clearAll()`, which resets all the bits to 0:

```swift
  public mutating func clearAll() {
    for i in 0..<words.count {
      words[i] = 0
    }
  }
```

There is also `setAll()` to make all the bits 1. However, this has to deal with a subtle issue.

```swift
  public mutating func setAll() {
    for i in 0..<words.count {
      words[i] = allOnes
    }
    clearUnusedBits()
  }
```

First, we copy ones into all the words in our array. The array is now:

```swift
1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111
```

But this is incorrect... Since we don't use most of the last word, we should leave those bits at 0:

```swift
1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111
1111111111110000000000000000000000000000000000000000000000000000
```

Instead of 192 one-bits we now have only 140 one-bits. The fact that the last word may not be completely filled up means that we always have to treat this last word specially.

Setting those "leftover" bits to 0 is what the `clearUnusedBits()` helper function does. If the `BitSet`'s size is not a multiple of `N` (i.e. 64), then we have to clear out the bits that we're not using. If we don't do this, bitwise operations between two differently sized `BitSet`s will go wrong (an example follows).

This uses some advanced bit manipulation, so pay close attention:

```swift
  private func lastWordMask() -> Word {
    let diff = words.count*N - size       // 1
    if diff > 0 {
      let mask = 1 << Word(63 - diff)     // 2
      return mask | (mask - 1)            // 3
    } else {
      return ~Word()
    }
  }

  private mutating func clearUnusedBits() {
    words[words.count - 1] &= lastWordMask()   // 4
  }  
```

Here's what it does, step-by-step:

1) `diff` is the number of "leftover" bits. In the above example that is 52 because `3*64 - 140 = 52`.

2) Create a mask that is all 0's, except the highest bit that's still valid is a 1. In our example, that would be:

	0000000000010000000000000000000000000000000000000000000000000000

3) Subtract 1 to turn it into:

	1111111111100000000000000000000000000000000000000000000000000000

and add the high bit back in to get:

	1111111111110000000000000000000000000000000000000000000000000000

There are now 12 one-bits in this word because `140 - 2*64 = 12`.

4) Finally, turn all the higher bits off. Any leftover bits in the last word are now all 0.

An example of where this is important is when you combine two `BitSet`s of different sizes. For the sake of illustration, let's take the bitwise OR between two 8-bit values:

	10001111  size=4
	00100011  size=8

The first one only uses the first 4 bits; the second one uses 8 bits. The first one should really be `10000000` but let's pretend we forgot to clear out those 1's at the end. Then a bitwise OR between the two results in:

	10001111  
	00100011  
	-------- OR
	10101111

That is wrong since two of those 1-bits aren't supposed to be here. The correct way to do it is:

	10000000       unused bits set to 0 first!
	00100011  
	-------- OR
	10100011

Here's how the `|` operator is implemented:

```swift
public func |(lhs: BitSet, rhs: BitSet) -> BitSet {
  var out = copyLargest(lhs, rhs)
  let n = min(lhs.words.count, rhs.words.count)
  for i in 0..<n {
    out.words[i] = lhs.words[i] | rhs.words[i]
  }
  return out
}
```

Note that we `|` entire words together, not individual bits. That would be way too slow! We also need to do some extra work if the left-hand side and right-hand side have a different number of bits: we copy the largest of the two `BitSet`s into the `out` variable and then combine it with the words from the smaller `BitSet`.

Example:

```swift
var a = BitSet(size: 4)
a.setAll()
a[1] = false
a[2] = false
a[3] = false
print(a)

var b = BitSet(size: 8)
b[2] = true
b[6] = true
b[7] = true
print(b)

let c = a | b
print(c)        // 1010001100000000...0
```

Bitwise AND (`&`), exclusive-OR (`^`), and inversion (`~`) are implemented in a similar manner.

## Counting the number of 1-bits

To count the number of bits that are set to 1 we could scan through the entire array -- an **O(n)** operation -- but there's a more clever method:

```swift
  public var cardinality: Int {
    var count = 0
    for var x in words {
      while x != 0 {
        let y = x & ~(x - 1)  // find lowest 1-bit
        x = x ^ y             // and erase it
        ++count
      }
    }
    return count
  }
```

When you write `x & ~(x - 1)`, it gives you a new value with only a single bit set. This is the lowest bit that is one. For example take this 8-bit value (again, I'm showing this with the least significant bit on the left):

	00101101

First we subtract 1 to get:

	11001101

Then we invert it, flipping all the bits:

	00110010

And take the bitwise AND with the original value:

	00101101
	00110010
	-------- AND
	00100000

The only value they have in common is the lowest (or least significant) 1-bit. Then we erase that from the original value using exclusive-OR:

	00101101
	00100000
	-------- XOR
	00001101

This is the original value but with the lowest 1-bit removed.

We keep repeating this process until the value consists of all zeros. The time complexity is **O(s)** where **s** is the number of 1-bits.

## Bit Shift Operations

Bit shifts are a common and very useful mechanism when dealing with bitsets. Here is the right-shift function:

```
public func >> (lhs: BitSet, numBitsRight: Int) -> BitSet {
    var out = lhs
    let offset = numBitsRight / lhs.N
    let shift = numBitsRight % lhs.N
    for i in 0..<lhs.words.count {
        out.words[i] = 0
        
        if (i + offset < lhs.words.count) {
            out.words[i] = lhs.words[i + offset] >> shift
        }
        
        if (i + offset + 1 < lhs.words.count) {
            out.words[i] |= lhs.words[i + offset + 1] << (lhs.N - shift)
        }
    }

    out.clearUnusedBits()
    return out
}
```

Let's start with this line:

```swift
for i in 0..<lhs.words.count {
```

This indicates our strategy: we want to go through each word of the result and assign the correct bits.

The two internal if-statements inside this loop are assigning some bits from one place in the source number and bitwise OR-ing them with some bits from a second place in the source number. The key insight here is that the bits for any one word of the result comes from at most two source words in the input. So the only remaining trick is to calculate which ones. For this, we need these two numbers:

```swift
let offset = numBitsRight / lhs.N
let shift = numBitsRight % lhs.N
```

Offset gives us how many words away from the source word we start getting our bits (with the remainder coming from it's neighbour). Shift gives us how many bits we need to shift within that word. Note that both of these are calcuated using the word size `lhs.N`.

All that's left if a little bit of protection against reading outside the bounds of the input. So these two if conditions protect against that:
```swift
if (i + offset < lhs.words.count) {
```
and
```swift
if (i + offset + 1 < lhs.words.count) {
```

Let's work through an example. Suppose our word length has been reduced to 8 bits, and we'd like to right-shift the following number by 10 bits:

    01000010 11000000 00011100      >> 10

I've grouped each part of the number by word to make it easier to see what happens. The for-loop goes from least significant word to most significant. So for index zero we're want to know what bits will make up our least significant word. Let's calculate our offset and shift values:

    offset = 10 / 8 = 1     (remember this is integer division)
    shift = 10 % 8 = 2

So we consult the word at offset 1 to get some of our bits:

    11000000 >> 2 = 00110000

And we get the rest of them from the word one further away:

    01000010 << (8 - 2) = 10000000
    
And we bitwise OR these together to get our least significant term

    00110000
    10000000
    -------- OR
    10110000

We repeat this for the 2nd least significant term and obtain:

    00010000

The last term can't get any bits because they are past the end of our number so those are all zeros. Our result is:

    00000000 00010000 10110000

## See also

[Bit Twiddling Hacks](http://graphics.stanford.edu/~seander/bithacks.html)

*Written for Swift Algorithm Club by Matthijs Hollemans*
