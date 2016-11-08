# Rootish Array Stack

A *Rootish Array Stack* is an ordered array based structure that minimizes wasted space (based on [Gauss's summation technique](https://betterexplained.com/articles/techniques-for-adding-the-numbers-1-to-100/)). A *Rootish Array Stack* consists of an array holding many fixed size arrays in ascending size.  

![Rootish Array Stack Intro](/images/RootishArrayStackIntro.png)
<!-- ![Rootish Array Stack Intro](https://github.com/raywenderlich/swift-algorithm-club/blob/master/Rootish%20Array%20Stack/images/RootishArrayStackIntro.png) -->

A resizable array holds references to blocks (arrays of fixed size). A block's capacity is the same as it's index in the resizable array. Blocks don't grow/shrink like regular Swift arrays. Instead, when their capacity is reached, a new slightly larger block is created. When a block is emptied the last block is freed. This is a great improvement on what a swift array does in terms of wasted space.

![Rootish Array Stack Intro](/images/RootishArrayStackExample.png)

Here you can see how insert/remove operations would behave (very similar to how a Swift array handles such operations).

### How indices map:
| Subscript index | Indices of Blocks|
| :------------- | :------------- |
| `[0]`       | `blocks[0][0]`       |

## A Mathematical Explanation
