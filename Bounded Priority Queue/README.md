# Bounded Priority queue

A bounded priority queue is similar to a regular [priority queue](../Priority Queue), except that there is a fixed upper bound on the number of elements that can be stored. Whenever a new element is added to the queue, if the queue is at capacity, the element with the highest priority value is ejected from the queue.

## Example
Supposed we have a bounded-priority-queue with maximum size 5 that has the following values and priorities:
```
Value:    [A,   B,    C,    D,   E]
Priority: [0.1, 0.25, 1.33, 3.2, 4.6]
```
Suppose that we want to insert the element `F` with priority `0.4` into this bounded priority queue. Because this bounded-priority-queue has maximum size five, this will insert the element `F`, but then evict the lowest-priority element (`E`), yielding the updated queue:
```
Value:    [A,   B,    F,   C,    D]
Priority: [0.1, 0.25, 0.4, 1.33, 3.2]
```
Now suppose that we wish to insert the element G with priority 4.0 into this BPQ. Because G's priority value is greater than the maximum-priority element in the BPQ, upon inserting G it will immediately be evicted. In other words, inserting an element into a BPQ with priority greater than the maximum-priority element of the BPQ has no effect.

## Implementation
While a [heap](../Heap) may be a really simple implementation for a priority queue, an sorted [linked list](../Linked List) allows for `O(k)` insertion and `O(1)` deletion. Where `k` is the bounding number of elements.
```swift
public func enqueue(value: T) {
    let newNode = Node(value: value)

    if head == nil  {
        head = newNode
    } else {
        var node = head
        if curNumElements == maxNumElements && !(newNode.value < node!.value) {
            return
        }

        while (node!.next != nil) && (newNode.value < node!.value) { node = node!.next }

        if newNode.value < node!.value {
            newNode.next = node!.next
            newNode.previous = node

            if(newNode.next != nil) { /* TAIL */
                newNode.next!.previous = newNode
            }
            node!.next = newNode
        } else {
            newNode.previous = node!.previous
            newNode.next = node
            if(node!.previous == nil) { /* HEAD */
                head = newNode
            } else {
                node!.previous!.next = newNode
            }
            node!.previous = newNode
        }
        if(curNumElements == maxNumElements) { dequeue() }
    }
    curNumElements += 1
}
```
The `enqueue(_:)` method checks if the queue already has the maximum number of elements. If the new value is greater than the `head` value then don't insert it. If the new value is less than `head` search through the list to find the proper insertion location and update the pointers.

Lastly if the queue has reached the maximum number of elements `dequeue()` the highest priority one.

By keeping the element with the highest priority as the head it allows for a simple update of the `head` variable in a `dequeue()`:
```swift
public func dequeue() -> T? {
    if curNumElements > 0 {
        let retVal = head!.value

        if curNumElements == 1 {
            head = nil
        }
        else {
            head = head!.next
            head!.previous = nil
        }

        curNumElements -= 1
        return retVal
    }
    return nil
}
```
