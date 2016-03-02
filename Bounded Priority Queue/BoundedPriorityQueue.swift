//
//  BoundedPriorityQueue.swift
//
//  Created by John Gill on 2/28/16.
//

import Foundation

public class LinkedListNode<T: Comparable> {
    var value: T
    var next: LinkedListNode?
    var previous: LinkedListNode?

    public init(value: T) {
        self.value = value
        self.next = nil
        self.previous = nil
    }
}

public class BoundedPriorityQueue<T: Comparable> {
    public typealias Node = LinkedListNode<T>
    private var head: Node?
    private var curNumElements:Int
    private var maxNumElements: Int

    public init(maxElements:Int) {
        head = nil
        maxNumElements = maxElements
        curNumElements = 0
    }

    public var isEmpty: Bool {
        return curNumElements == 0
    }

    public var count: Int {
        return curNumElements
    }

    public func peek() -> T? {
        if curNumElements > 0 {
            return head!.value
        }
        return nil
    }

    public func enqueue(value: T) {
        let newNode = Node(value: value)

        if head == nil  {
            head = newNode
        } else {
            var node = head
            if curNumElements == maxNumElements && newNode.value > node!.value {
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
}
