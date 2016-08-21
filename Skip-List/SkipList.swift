// The MIT License (MIT)

// Copyright (c) 2016 Mike Taghavi (mitghi[at]me.com)

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


import Foundation


// Stack from : https://github.com/raywenderlich/swift-algorithm-club/tree/master/Stack
public struct Stack<T> {
    private var array = [T]()

    public var isEmpty: Bool {
        return array.isEmpty
    }

    public var count: Int {
        return array.count
    }

    public mutating func push(element: T) {
        array.append(element)
    }

    public mutating func pop() -> T? {
        return array.popLast()
    }

    public func peek() -> T? {
        return array.last
    }
}

extension Stack: SequenceType {
    public func generate() -> AnyGenerator<T> {
        var curr = self
        return AnyGenerator {
                   _ -> T? in
                   return curr.pop()
            }
    }
}


func random() -> Bool {
    #if os(Linux)
        return random() % 2 == 0
    #elseif os(OSX)
        return arc4random_uniform(2) == 1
    #endif
}



class DataNode<Key: Comparable, Payload>{
    internal typealias Node = DataNode<Key,Payload>
    
    internal var key   : Key?
    internal var data  : Payload?
    internal var _next : Node?
    internal var _down : Node?

    internal var next: Node? {
        get        { return self._next  }
        set(value) { self._next = value }        
    }

    internal var down:Node? {
        get        { return self._down  }
        set(value) { self._down = value }
    }
    
    init(key:Key, data:Payload){
        self.key  = key
        self.data = data
    }

    init(header: Bool){        
    }
    
}


class SkipList<Key: Comparable, Payload>{
    internal typealias Node = DataNode<Key, Payload>
    internal var head: Node?

    private func find_head(key:Key) -> Node? {
        var current     = self.head
        var found: Bool = false

        while !found {
            if let curr = current {
                if curr.next == nil { current = curr.down }
                else {
                    if curr.next!.key == key { found = true }
                    else {                        
                        if key < curr.next!.key{ current = curr.down }
                        else { current = curr.next }
                    }
                }
            } else {
                break
            }
        }

        if found {
            return current
        } else {
            return nil
        }        
    }
    

    private func insert_head(key:Key, data:Payload) -> Void {
        
        self.head       = Node(header: true)
        var temp        = Node(key:key, data:data)
        self.head!.next = temp
        var top         = temp

        while random() {
            let newhead  = Node(header: true)
            temp         = Node(key:key, data:data)
            temp.down    = top
            newhead.next = temp
            newhead.down = self.head
            self.head    = newhead
            top          = temp                
        }
    }

    private func insert_rest(key:Key, data:Payload) -> Void {
        var stack = Stack<Node>()
        var current_head: Node? = self.head

        while current_head != nil {

            if let next = current_head!._next {
                if next.key > key {
                    stack.push(current_head!)
                    current_head = next
                } else {
                    current_head = next
                }
                
            } else {
                stack.push(current_head!)
                current_head = current_head!.down                    
            }
            
        }            

        let lowest   = stack.pop()
        var temp     = Node(key:key, data:data)
        temp.next    = lowest!.next
        lowest!.next = temp
        var top      = temp

        while random() {
            if stack.isEmpty {
                let newhead  = Node(header: true)
                temp         = Node(key:key, data:data)
                temp.down    = top
                newhead.next = temp
                newhead.down = self.head
                self.head    = newhead
                top          = temp
            } else {
                let next   = stack.pop()
                temp       = Node(key:key, data:data)
                temp.down  = top
                temp.next  = next!.next
                next!.next = temp
                top        = temp
            }
        }        
    }
    
    func search(key:Key) -> Payload? {
        guard let item = self.find_head(key) else {
            return nil
        }

        return item.next!.data        
    }
    
    func remove(key:Key) -> Void {
        guard let item = self.find_head(key) else {
            return
        }
        
        var curr = Optional(item)
        
        while curr != nil {
            let node      = curr!.next
            
            if node!.key != key { curr = node ; continue }

            let node_next = node!.next            
            curr!.next    = node_next
            curr          = curr!.down
            
        }
        
    }
    
    func insert(key: Key, data:Payload){
        if self.head != nil{
            if let node = self.find_head(key) {
                
                var curr = node.next                
                while curr != nil && curr!.key == key{
                    curr!.data = data
                    curr       = curr!.down
                }
                
            } else {                        
                self.insert_rest(key, data:data)
            }
            
        } else {
            self.insert_head(key, data:data)
        }
    }

}


class Map<Key: Comparable, Payload>{    
    var collection: SkipList<Key, Payload>

    init(){
        self.collection = SkipList<Key, Payload>()
    }
    
    func insert(key:Key, data: Payload){
        self.collection.insert(key, data:data)
    }

    func get(key:Key) -> Payload?{
        return self.collection.search(key)
    }
    
    func remove(key:Key) -> Void {
        return self.collection.remove(key)
    }
}
