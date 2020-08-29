struct Message: Comparable, CustomStringConvertible {
  let name: String
  let priority: Int

  var description: String {
    return "\(name):\(priority)"
  }
}

func == (m1: Message, m2: Message) -> Bool {
  return m1.priority == m2.priority
}

func < (m1: Message, m2: Message) -> Bool {
  return m1.priority < m2.priority
}

let queue = BoundedPriorityQueue<Message>(maxElements: 5)
queue.count

queue.enqueue(Message(name: "hello", priority: 100))
queue.count
queue.peek()
print(queue)

queue.enqueue(Message(name: "there", priority: 99))
queue.count
queue.peek()
print(queue)

queue.enqueue(Message(name: "world", priority: 150))
queue.count
queue.peek()
print(queue)

queue.enqueue(Message(name: "swift", priority: 110))
queue.count
queue.peek()
print(queue)

queue.enqueue(Message(name: "is", priority: 30))
queue.count
queue.peek()
print(queue)

// At this point, the queue is:
// <world:150, swift:110, hello:100, there:99, is:30, >

// Try to insert an item with a really low priority. This should not get added.
queue.enqueue(Message(name: "very", priority: -1))
queue.count    // 5
queue.peek()
print(queue)   // still same as before

// Try to insert an item with medium priority. This gets added and the lowest
// priority item is removed.
queue.enqueue(Message(name: "cool", priority: 120))
queue.count
queue.peek()
print(queue)

// Try to insert an item with very high priority. This gets added and the
// lowest priority item is removed.
queue.enqueue(Message(name: "!!!", priority: 500))
queue.count
queue.peek()
print(queue)

// Test dequeuing
queue.dequeue()
queue.count
queue.peek()
print(queue)

queue.dequeue()
queue.count
queue.peek()
print(queue)

queue.dequeue()
queue.count
queue.peek()
print(queue)

queue.dequeue()
queue.count
queue.peek()
print(queue)

queue.dequeue()
queue.count
queue.peek()
print(queue)

queue.dequeue()
queue.count
queue.peek()
print(queue)
