/* Singly Linked List
Provides O(n) for storage and lookup.
*/

class Node<T> {
    var key: T?
    var next: Node?
    
    init() {}
    init(key: T?) { self.key = key }
    init(key: T?, next: Node?) {
        self.key = key
        self.next = next
    }
}

class SinglyLinkedList<T: Equatable> {
    
    var head = Node<T>()
    
    func addLink(key: T) {
        guard head.key != nil else { return head.key = key }
        
        var current: Node? = head
        
        FindEmptySpot: while current != nil {
            if current?.next == nil {
                current?.next = Node<T>(key: key)
                break FindEmptySpot
            } else {
                current = current?.next
            }
        }
    }
    
    func removeLinkAtIndex(index: Int)  {
        guard index >= 0 && index <= self.count - 1  && head.key != nil else { return  }
        
        var current: Node<T>? = head
        var trailer: Node<T>?
        var listIndex = 0
        
    
        if index == 0 {
            current = current?.next
            head = current?.next ?? Node<T>()
            return
        }
        
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
}



