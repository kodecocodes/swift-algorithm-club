# Rootish Array Stack

A *Rootish Array Stack* is an ordered array based structure that minimizes wasted space (based on [Gauss's summation technique](https://betterexplained.com/articles/techniques-for-adding-the-numbers-1-to-100/)). A *Rootish Array Stack* consists of an array holding many fixed size arrays in ascending size.  

![Rootish Array Stack Intro](images/RootishArrayStackIntro.png)

A resizable array holds references to blocks (arrays of fixed size). A block's capacity is the same as it's index in the resizable array. Blocks don't grow/shrink like regular Swift arrays. Instead, when their capacity is reached, a new slightly larger block is created. When a block is emptied the last block is freed. This is a great improvement on what a swift array does in terms of wasted space.

![Rootish Array Stack Intro](images/RootishArrayStackExample.png)

Here you can see how insert/remove operations would behave (very similar to how a Swift array handles such operations).

## The Math
The data structure is based on Gauss's summation technique:
```
sum from 1...n = n * (n + 1) / 2
```
To understand this imagine `n` blocks where `x` represents `1` unit. In this example let `n` be `5`:
```
blocks:     [x] [x x] [x x x] [x x x x] [x x x x x]
# of x's:    1    2      3        4          5
```
_Block `1` has 1 `x`, block `2` as 2 `x`s, block `3` has 3 `x`s, etc..._

If you wanted to take the sum of all the blocks from `1` to `n` you could go through and count them _one by one_. This is okay, but for a large sequence of blocks that could take a long time! Instead you could arrange the blocks to look like a _half pyramid_:
```
# |  blocks
--|-------------
1 |  x
2 |  x x
3 |  x x x
4 |  x x x x
5 |  x x x x x

```
Then we mirror the _half pyramid_ and rearrange the image so that it fits with the original _half pyramid_ in a rectangular shape:
```
x                  o      x o o o o o
x x              o o      x x o o o o
x x x          o o o  =>  x x x o o o
x x x x      o o o o      x x x x o o
x x x x x  o o o o o      x x x x x o
```
Here we have `n` rows and `n + 1` columns of units. _5 rows and 6 columns_.

We could calculate sum just as we would an area! Lets also express width and hight in terms of `n`:
```
area of a rectangle = height * width = n * (n + 1)
```
But we only want to calculate the amount of `x`s, not the amount of `o`s. Since there's a 1:1 ratio between `x`s and `o`s we and just divide our area by 2!
```
area of only x = n * (n + 1) / 2
```
And voila! We have an interesting new way to arrange our data!

## Get/Set with Speed
Next we want to find an efficient way to access a random index. For example which block does `rootishArrayStack[12]` point to? To answer this we will need MORE MATH!
Determining the inner block `index` turns out to be easy. If `index` is in some `block` then:
```
inner block index = index - block * (block + 1) / 2
```

More difficult is determining which `block` an index points to. The number of elements that have indices less than or equal to the the requested `index` is: `index + 1` elements. The number of elements in blocks `0...block` is `(block + 1) * (block + 2) / 2`. Therefore, `block` is the smaller integer such that:
```
(block + 1) * (block + 2) / 2 >= index + 1
```
This can be rewritten as:
```
(block)^2 + (3 * block) - (2 * index) >= 0
```
Using the quadratic formula we can get:
```
block = (-3 ± √(9 + 8 * index)) / 2
```
A negative block doesn't make sense so we take the positive root instead. In general this solution is not an integer but going back to our inequality, we want the smallest block such that `b => (-3 + √(9 + 8 * index)) / 2`. So we take the ceiling of the result:
```
block = ⌈(-3 + √(9 + 8 * index)) / 2⌉
```

Now we can figure out that `rootishArrayStack[12]` would point to the block at index `4` and at inner block index `2`.
![Rootish Array Stack Intro](images/RootishArrayStackExample2.png)

# The Code

To get the `capacity` of the structure we can use the equation we figured out above:
```swift
var capacity: Int {
  return blocks.count * (blocks.count + 1) / 2
}
```
Since Swift arrays check `count` in `O(1)` time, this capacity lookup is also `O(1)`.

To solve the problem of which block holds the block holds the element we are looking for we need
