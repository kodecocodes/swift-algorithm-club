# Singly Linked List

Singly linked lists are basic data structures that enable linking of related elements. Linked lists are not unlike arrays. They provide insertion, retrieval, updating, and removal of their elements. The elements of a linked list are referred to as 'nodes.' Each node has two properties: a value, and pointer the the next node in the list.They provide O(n) time for storage and lookup. See below for the memory implications and differences between singly and doubly linked lists.

## Linked List vs. Array

One major difference between linked lists and arrays are that the elements of a linked list are not stored 'contiguously' in memory as in an array. This means that elements can be inserted or removed without having to reorganize their entire structure. Conversely, linked lists do not random access to the data or efficient indexing of their elements.

## Singly linked list vs. Doubly linked list

A singly linked list's nodes contain only their key (or data) and a pointer to the next node in the list. A Doubly linked list contains nodes that have a key, a pointer to the next node, and also a pointer to the previous node in the list.
Doubly linked lists require more memory per node, but can provide easier manipulation than singly linked lists. 

In Swift, you might write a simple data structure to represent a node that holds nintegers like this:

```swift
class Node {
	var key: Int
	var next: Node?
}
```

Note the type of the 'next' property. If we are at the end of our list or if our list is empty, there is no next link. Because of this, 'next' is of type optional node. What if we want a linked list of something other than integers, or support nil-values for keys? We can make our data structure generic.

```swift
class Node<T> {
	var key: T?
	var next: Node<T>?
}
```

## Head and Tail

A linked list's first node is referred to as its 'head'. The term 'tail' can be used to refer to the last node in the list, or to all the nodes in the list after the head.

To create a linked list of nodes, we create a class with a generic type. Because we'll need to compare the nodes on the basis of equality, we constrain our generic type 'T' to conform to Swift's Equatable protocol.

Here is one implementation of a singly linked list in Swift:

```swift
class SinglyLinkedList<T: Equatable> {
	var head = Node<T>()
}
```

To support insertion of nodes to the list, we write a function that takes a key of type 'T'. 

```swift
 func addLink(key: T) {
 		
 		 /* Check if the head's key is nil, and if so, 
 		 assign it the value of the parameter passed in */
 
        guard head.key != nil else { return head.key = key }
        
        //create local variable and initialize it with the head
        var current: Node? = head
        
        /* Begin while loop that finds the last node in the list and creates
         a new node with the value of the parameter at the end of the list */
        FindEmptySpot: while current != nil {
            if current?.next == nil {
                current?.next = Node<T>(key: key)
                break FindEmptySpot
            } else {
                current = current?.next
            }
        }
    }
```

Before we can write a function that removes a node by its index, we'll need to know the count of nodes in our list. We'll also include a computed property that will tell us if a list is empty.

```swift
var count: Int {
        guard head.key != nil else { return 0 }
        var current = head
        var x = 1
        while let next = current.next {
            current = next
            x += 1
        }
        return x
    }
    
    var isEmpty: Bool {
        return head.key == nil
    }
```

To support deletion of nodes in the list, we write a function that accepts the index of the node to remove. We'll have to reorganize the nodes that surround the link that is removed.

```swift
 func removeLinkAtIndex(index: Int)  {
  		 /* Verify that the index passed as an argument to the function
 		 is >= the index of the head and <= the last node in the list.
 		 If the list is empty, we'll simply return. */
 
        guard index >= 0 && index <= self.count - 1  && head.key != nil else { return  }
        
        
        /* Create local variables for the current node,
         the trailing node, and an index */
        the current node with the head node */
        
        var current: Node<T>? = head
        var trailer: Node<T>?
        var listIndex = 0
        
    	/* If the link to be removed is the head */
        if index == 0 {
            current = current?.next
            head = current?.next ?? Node<T>()
            return
        }
        
        /* Begin while loop that shuffles through the nodes in the list.
         When the index of the node to be removed is reached, we assign 
         the node a nil value, and break out of the loop */
        while current != nil {
            if listIndex == index {
                trailer?.next = current?.next
                current = nil
                break
            }
            trailer = current
            current = current?.next
            listIndex += 1
        }
    }
```

Linked lists are relatively simple structures, but can be used to implement other common data types like stacks and queues. It can be helpful to better understand how they differ from the Array type and what memory and efficiency implications are associated with their use.

*Written for Swift Algorithm Club by [Mac Bellingrath](https://github.com/macbellingrath)*
