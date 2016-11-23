# Ring Buffer

Also known as a circular buffer.

The problem with a [queue based on an array](../Queue/) is that adding new items to the back of the queue is fast, **O(1)**, but removing items from the front of the queue is slow, **O(n)**. Removing is slow because it requires the remaining array elements to be shifted in memory.

A more efficient way to implement a queue is to use a ring buffer or circular buffer. This is an array that conceptually wraps around back to the beginning, so you never have to remove any items. All operations are **O(1)**.

Here is how it works in principle. We have an array of a fixed size, say 5 items:

	[    ,    ,    ,    ,     ]
	 r
	 w

Initially, the array is empty and the read (`r`) and write (`w`) pointers are at the beginning.

Let's add some data to this array. We'll write, or "enqueue", the number `123`:

	[ 123,    ,    ,    ,     ]
	  r
	  ---> w

Each time we add data, the write pointer moves one step forward. Let's add a few more elements:

	[ 123, 456, 789, 666,     ]
	  r    
	       -------------> w

There is now one open spot left in the array, but rather than enqueuing another item the app decides to read some data. That's possible because the write pointer is ahead of the read pointer, meaning data is available for reading. The read pointer advances as we read the available data:

	[ 123, 456, 789, 666,     ]
	  ---> r              w

Let's read two more items:

	[ 123, 456, 789, 666,     ]
	       --------> r    w

Now the app decides it's time to write again and enqueues two more data items, `333` and `555`:

	[ 123, 456, 789, 666, 333 ]
	                 r    ---> w

Whoops, the write pointer has reached the end of the array, so there is no more room for object `555`. What now? Well, this is why it's a circular buffer: we wrap the write pointer back to the beginning and write the remaining data:

	[ 555, 456, 789, 666, 333 ]
	  ---> w         r        

We can now read the remaining three items, `666`, `333`, and `555`.

	[ 555, 456, 789, 666, 333 ]
	       w         --------> r        

Of course, as the read pointer reaches the end of the buffer it also wraps around:

	[ 555, 456, 789, 666, 333 ]
	       w            
	  ---> r

And now the buffer is empty again because the read pointer has caught up with the write pointer.

Here is a very basic implementation in Swift:

```swift
public struct RingBuffer<T> {
  fileprivate var array: [T?]
  fileprivate var readIndex = 0
  fileprivate var writeIndex = 0

  public init(count: Int) {
    array = [T?](repeating: nil, count: count)
  }

  public mutating func write(_ element: T) -> Bool {
    if !isFull {
      array[writeIndex % array.count] = element
      writeIndex += 1
      return true
    } else {
      return false
    }
  }

  public mutating func read() -> T? {
    if !isEmpty {
      let element = array[readIndex % array.count]
      readIndex += 1
      return element
    } else {
      return nil
    }
  }

  fileprivate var availableSpaceForReading: Int {
    return writeIndex - readIndex
  }

  public var isEmpty: Bool {
    return availableSpaceForReading == 0
  }

  fileprivate var availableSpaceForWriting: Int {
    return array.count - availableSpaceForReading
  }

  public var isFull: Bool {
    return availableSpaceForWriting == 0
  }
}
```

The `RingBuffer` object has an array for the actual storage of the data, and `readIndex` and `writeIndex` variables for the "pointers" into the array. The `write()` function puts the new element into the array at the `writeIndex`, and the `read()` function returns the element at the `readIndex`.

But hold up, you say, how does this wrapping around work? There are several ways to accomplish this and I chose a slightly controversial one. In this implementation, the `writeIndex` and `readIndex` always increment and never actually wrap around. Instead, we do the following to find the actual index into the array:

```swift
array[writeIndex % array.count]
```

and:

```swift
array[readIndex % array.count]
```

In other words, we take the modulo (or the remainder) of the read index and write index divided by the size of the underlying array.

The reason this is a bit controversial is that `writeIndex` and `readIndex` always increment, so in theory these values could become too large to fit into an integer and the app will crash. However, a quick back-of-the-napkin calculation should take away those fears.

Both `writeIndex` and `readIndex` are 64-bit integers. If we assume that they are incremented 1000 times per second, which is a lot, then doing this continuously for one year requires `ceil(log_2(365 * 24 * 60 * 60 * 1000)) = 35` bits. That leaves 28 bits to spare, so that should give you about 2^28 years before running into problems. That's a long time. :-)

To play with this ring buffer, copy the code to a playground and do the following to mimic the example above:

```swift
var buffer = RingBuffer<Int>(count: 5)

buffer.write(123)
buffer.write(456)
buffer.write(789)
buffer.write(666)

buffer.read()   // 123
buffer.read()   // 456
buffer.read()   // 789

buffer.write(333)
buffer.write(555)

buffer.read()   // 666
buffer.read()   // 333
buffer.read()   // 555
buffer.read()   // nil
```

You've seen that a ring buffer can make a more optimal queue but it also has a disadvantage: the wrapping makes it tricky to resize the queue. But if a fixed-size queue is suitable for your purposes, then you're golden.

A ring buffer is also very useful for when a producer of data writes into the array at a different rate than the consumer of the data reads it. This happens often with file or network I/O. Ring buffers are also the preferred way of communicating between high priority threads (such as an audio rendering callback) and other, slower, parts of the system.

The implementation given here is not thread-safe. It only serves as an example of how a ring buffer works. That said, it should be fairly straightforward to make it thread-safe for a single reader and single writer by using `OSAtomicIncrement64()` to change the read and write pointers.

A cool trick to make a really fast ring buffer is to use the operating system's virtual memory system to map the same buffer onto different memory pages. Crazy stuff but worth looking into if you need to use a ring buffer in a high performance environment.

*Written for Swift Algorithm Club by Matthijs Hollemans*
