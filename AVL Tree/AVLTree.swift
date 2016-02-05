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

class TreeNode<Key:Comparable,Payload:Comparable>{
    var key: Key
    var value: Payload?
    var balance: Int = 0
    var leftChild: TreeNode<Key,Payload>?
    var rightChild: TreeNode<Key,Payload>?
    var parent: TreeNode<Key,Payload>?

    init(key: Key, value: Payload,leftChild: TreeNode<Key,Payload>?, rightChild: TreeNode<Key,Payload>?, parent: TreeNode<Key,Payload>?){
        self.key = key
        self.value = value        
        self.leftChild = leftChild
        self.rightChild = rightChild
        self.parent = parent
    }

    init(key: Key){
        self.key = key
        self.value = nil
        self.leftChild = nil
        self.rightChild = nil
        self.parent = nil        
    }

    init(key: Key,value: Payload){
        self.key = key
        self.value = value
        self.leftChild = nil
        self.rightChild = nil
        self.parent = nil
    }

    var isRoot: Bool {
        return self.parent == nil
    }

    var isLeftChild: Bool {
        return self.parent != nil && self.parent!.leftChild === self
    }

    var isRightChild: Bool {
        return self.parent != nil && self.parent!.rightChild === self
    }    

    var hasLeftChild: Bool {
        return self.leftChild != nil
    }

    var isLeaf: Bool {
        return self.rightChild == nil && self.leftChild == nil
    }

    var hasRightChild: Bool {
        return self.rightChild != nil
    }

    var hasAnyChild: Bool {
        return self.leftChild != nil || self.rightChild != nil
    }

    var hasBothChilds: Bool {
        return self.leftChild != nil && self.rightChild != nil        
    }
    

    func findmin() -> TreeNode? {
        var curr: TreeNode? = self
        while (curr != nil) && curr!.hasLeftChild {
            curr = curr!.leftChild
        }
        return curr
    }

    func find_successor() -> TreeNode<Key,Payload>? {
        var res: TreeNode<Key,Payload>?
        
        if self.hasRightChild{
            res = self.rightChild!.findmin()
        } else {
            if let parent = self.parent {
                if self.isLeftChild {
                    res = parent
                } else {
                    parent.rightChild = nil
                    res = parent.find_successor()
                    parent.rightChild = self
                }
            }
        }

        return res
    }

    func spliceout(){
        if self.isLeaf {
            if self.isLeftChild {
                self.parent!.leftChild = nil
            } else if self.isRightChild {
                self.parent!.rightChild = nil
            }
        } else if self.hasAnyChild{
            if self.hasLeftChild{
                self.parent!.leftChild = self.leftChild!
            } else {
                self.parent!.rightChild = self.rightChild!
            }
            self.leftChild!.parent = self.parent!
        } else {
            if self.isLeftChild{
                self.parent!.leftChild = self.rightChild!
            } else {
                self.parent!.rightChild = self.rightChild!
            }
            self.rightChild!.parent = self.parent!
        }        
    }

    func replace_nodedata(key: Key,_ value: Payload, _ leftChild: TreeNode<Key,Payload>?,_ rightChild: TreeNode<Key,Payload>?){
        self.key = key
        self.value = value
        self.leftChild = leftChild
        self.rightChild = rightChild

        if self.hasLeftChild{
            self.leftChild!.parent! = self
        }

        if self.hasRightChild{
            self.rightChild!.parent! = self
        }
    }    
}

class AVLTree<Key:Comparable,Payload:Comparable> {
    var root: TreeNode<Key,Payload>?
    var size: Int = 0

    func insert(input: Key,_ value: Payload) {
        if self.size == 0 {
            self.root = TreeNode<Key,Payload>(key:input,value:value)                        
            self.size += 1
            return
        } else if self.size >= 1 {

            self._insert(input,value,self.root)
            self.size += 1
        }
        
    }

    subscript(key: Key) -> Payload? {
        get {
            return self.get(key)
        }
        set {
            self.insert(key,newValue!)
        }
    }

    private func _insert(input: Key, _ value: Payload, _ node :TreeNode<Key,Payload>?){
        if input < node!.key {
            if node!.hasLeftChild {
                self._insert(input,value, node!.leftChild!)
            } else {
                node!.leftChild = TreeNode<Key,Payload>(key: input, value: value,leftChild: nil,rightChild: nil,parent:node!)
                self.updatebalance(node!.leftChild)
            }
        } else {
            if node!.hasRightChild{
                self._insert(input,value,node!.rightChild!)
            } else {
                node!.rightChild = TreeNode<Key,Payload>(key: input, value: value,leftChild: nil,rightChild: nil,parent:node!)
                self.updatebalance(node!.rightChild)
            }
        }
    }

    func updatebalance(node: TreeNode<Key,Payload>?){
        if node!.balance > 1 || node!.balance < -1 {
            self.rebalance(node)
            return
                  
        } else {
            
            if node!.parent != nil {
                if node!.isLeftChild {
                    node!.parent!.balance += 1                
                } else if node!.isRightChild{
                    node!.parent!.balance -= 1
                }

                if node!.parent!.balance != 0 {
                    self.updatebalance(node!.parent)
                }            
            }
        }
        
    }

    func rebalance(node: TreeNode<Key,Payload>?){
        if node!.balance < 0 {
            if node!.rightChild != nil && node!.rightChild!.balance > 0 {
                self.rotateright(node!.rightChild)
                self.rotateleft(node)
            } else {
                self.rotateleft(node)
            }
        } else if node!.balance > 0 {
            if node!.leftChild != nil && node!.leftChild!.balance < 0 {
                self.rotateleft(node!.leftChild)
                self.rotateright(node)
            } else {
                self.rotateright(node)
            }
        }
    }

    func rotateright(node: TreeNode<Key,Payload>?){
        let newroot: TreeNode<Key,Payload>? = node!.leftChild
        node!.leftChild = newroot!.rightChild
        
        if newroot!.rightChild != nil{
            newroot!.rightChild!.parent = node            
        }
        newroot!.parent = node!.parent
        
        if node!.isRoot {
            self.root = newroot
        } else {
            if node!.isRightChild {
                node!.parent!.rightChild = newroot
            }else if node!.isLeftChild{
                node!.parent!.leftChild = newroot
            }
        }
        newroot!.rightChild = node
        node!.parent = newroot
        node!.balance = node!.balance + 1 - min(newroot!.balance,0)
        newroot!.balance = newroot!.balance + 1 - max(node!.balance,0)
    }

    func rotateleft(node: TreeNode<Key,Payload>?){
        let newroot: TreeNode<Key,Payload>? = node!.rightChild

        node!.rightChild = newroot!.leftChild

        if newroot!.leftChild != nil {
            newroot!.leftChild!.parent = node            
        }

        newroot!.parent = node!.parent

        if node!.isRoot {
            self.root = newroot
        } else {
            if node!.isLeftChild {
                node!.parent!.leftChild = newroot                
            }else if node!.isRightChild{
                node!.parent!.rightChild = newroot
            }
        }
        newroot!.leftChild = node
        node!.parent = newroot
        node!.balance = node!.balance + 1 - min(newroot!.balance,0)
        newroot!.balance = newroot!.balance + 1 - max(node!.balance,0)
    }
    
    func get(input: Key) -> Payload? {
        guard self.size >= 1 else { return nil }
        let result = self._get(input,self.root)
        
        return result != nil ?
               result!.value : nil
    }

    private func _get(key: Key, _ node: TreeNode<Key,Payload>?) -> TreeNode<Key,Payload>? {
        guard node != nil else { return nil }

        if key == node!.key { return node }
        else if key < node!.key { return self._get(key,node!.leftChild) }
        else if key > node!.key { return self._get(key,node!.rightChild) }

        return nil
    }

    func delete(key: Key){
        guard self.size >= 1 else { return }

        if self.size == 1 {
            self.root = nil
            self.size -= 1
            return 
        }
        
        let item = self._get(key,self.root)

        if let item = item { self._delete(item) }
        self.size -= 1
    }

    private func _delete(item: TreeNode<Key,Payload>){
        if item.isLeaf {
            if item.isLeftChild{
                item.parent!.leftChild = nil
            } else if item.isRightChild {
                item.parent!.rightChild = nil
            }            
        } else if item.hasBothChilds {
            let _item = item.find_successor()
            _item!.spliceout()
            item.key = _item!.key
            item.value = _item!.value
            
            if item.hasAnyChild {
                if item.hasBothChilds{
                    item.balance = max(item.leftChild!.balance,item.rightChild!.balance) + 1
                } else if item.hasRightChild {
                    item.balance = item.rightChild!.balance + 1
                } else if item.hasLeftChild {
                    item.balance = item.leftChild!.balance + 1
                }                
            }
            
        } else if item.hasLeftChild {
            if item.isLeftChild {
                item.leftChild!.parent = item.parent
                item.parent!.leftChild = item.leftChild
                item.balance = item.leftChild!.balance + 1
            } else if item.isRightChild{
                item.leftChild!.parent = item.parent
                item.parent!.rightChild = item.rightChild
                item.balance = item.rightChild!.balance + 1                
            } else {
                item.replace_nodedata(item.leftChild!.key,item.leftChild!.value!,item.leftChild!.leftChild,item.leftChild!.rightChild)
            }
        } else if item.hasRightChild{
            if item.isRightChild{
                item.rightChild!.parent = item.parent
                item.parent!.rightChild = item.rightChild
                item.balance = item.rightChild!.balance + 1
            } else if item.isLeftChild{
                item.rightChild!.parent = item.parent
                item.parent!.leftChild = item.leftChild
                item.balance = item.leftChild!.balance + 1
            } else {
                item.replace_nodedata(item.rightChild!.key,item.rightChild!.value!,item.rightChild!.leftChild,item.rightChild!.rightChild)
            }
        }
        
    }

    func print_values() {
        self._print_values(self.root)
    }
    
    private func _print_values(node: TreeNode<Key,Payload>?) {
        if let node = node {
            self._print_values(node.leftChild)
            print("\(node.key) -> \(node.value!). Balance : \(node.balance)")
            self._print_values(node.rightChild)            
        }
    }
}


