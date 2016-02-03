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

class TreeNode<A:Comparable,B:Comparable>{
    var key: A
    var value: B!
    var leftchild: TreeNode<A,B>?
    var rightchild: TreeNode<A,B>?
    var parent: TreeNode<A,B>?

    init(key: A, value: B,leftchild: TreeNode<A,B>?, rightchild: TreeNode<A,B>?, parent: TreeNode<A,B>?){
        self.key = key
        self.value = value
        self.leftchild = leftchild
        self.rightchild = rightchild
        self.parent = parent
    }

    init(key: A){
        self.key = key
        self.value = nil
        self.leftchild = nil
        self.rightchild = nil
        self.parent = nil
    }

    init(key: A,value: B){
        self.key = key
        self.value = value
        self.leftchild = nil
        self.rightchild = nil
        self.parent = nil
    }

    func isroot() -> Bool {
        return self.parent == nil
    }

    func is_leftchild() -> Bool {
        return self.parent != nil && self.parent!.leftchild === self
    }

    func is_rightchild() -> Bool {
        return self.parent != nil && self.parent!.rightchild === self
    }

    func has_leftchild() -> Bool {
        return self.leftchild != nil
    }

    func is_leaf() -> Bool {
        return self.rightchild == nil && self.leftchild == nil
    }

    func has_rightchild() -> Bool {
        return self.rightchild != nil
    }

    func has_anychild() -> Bool {
        return self.leftchild != nil || self.rightchild != nil
    }

    func has_bothchild() -> Bool {
        return self.leftchild != nil && self.rightchild != nil
    }

    func findmin() -> TreeNode? {
        var curr:TreeNode? = self
        while (curr != nil) && curr!.has_leftchild() {
            curr = curr!.leftchild
        }
        return curr
    }

    func find_successor() -> TreeNode<A,B>? {
        var res: TreeNode<A,B>?
        if self.has_rightchild(){
            res = self.rightchild!.findmin()
        } else {
            if self.parent != nil {
                if self.is_leftchild() {
                    res = self.parent!
                } else {
                    self.parent!.rightchild = nil
                    res = self.parent!.find_successor()
                    self.parent!.rightchild = self
                }
            }
        }

        return res
    }

    func spliceout(){
        if self.is_leaf(){
            if self.is_leftchild() {
                self.parent!.leftchild = nil
            } else if self.is_rightchild() {
                self.parent!.rightchild = nil
            }
        } else if self.has_anychild(){
            if self.has_leftchild(){
                self.parent!.leftchild = self.leftchild!
            } else {
                self.parent!.rightchild = self.rightchild!
            }
            self.leftchild!.parent = self.parent!
        } else {
            if self.is_leftchild(){
                self.parent!.leftchild = self.rightchild!
            } else {
                self.parent!.rightchild = self.rightchild!
            }
            self.rightchild!.parent = self.parent!
        }
        
    }

    func replace_nodedata(key: A,_ value: B, _ leftchild: TreeNode<A,B>?,_ rightchild: TreeNode<A,B>?){
        self.key = key
        self.value = value
        self.leftchild = leftchild
        self.rightchild = rightchild

        if self.has_leftchild(){
            self.leftchild!.parent! = self
        }

        if self.has_rightchild(){
            self.rightchild!.parent! = self
        }
    }    
}

class BinaryTree<A:Comparable,B:Comparable> {
    var root: TreeNode<A,B>?
    var size: Int = 0

    func insert(input: A,_ value: B) {
        if self.size == 0 {
            self.root = TreeNode<A,B>(key:input,value:value)
            self.size += 1
            return
        } else if self.size >= 1 {

            self.insert_in(input,value,self.root)
            self.size += 1
        }
        
    }

    subscript(key: A) -> B? {
        get {
            return self.get(key)
        }
        set {
            self.insert(key,newValue!)
        }
    }

    func insert_in(input: A, _ value: B, _ node :TreeNode<A,B>?){
        if input < node!.key {
            if node!.has_leftchild() {
                self.insert_in(input,value, node!.leftchild!)
            } else {
                node!.leftchild = TreeNode<A,B>(key: input, value: value,leftchild: nil,rightchild: nil,parent:node!)
            }
        } else {
            if node!.has_rightchild(){
                self.insert_in(input,value,node!.rightchild!)
            } else {
                node!.rightchild = TreeNode<A,B>(key: input, value: value,leftchild: nil,rightchild: nil,parent:node!)                
            }
        }
    }

    func get(input: A) -> B? {
        guard self.size >= 1 else { return nil }
        let result = self._get(input,self.root)
        
        return result != nil ?
               result!.value : nil
    }

    func _get(key: A, _ node: TreeNode<A,B>?) -> TreeNode<A,B>? {
        guard node != nil else { return nil }

        if key == node!.key { return node }
        else if key < node!.key { return self._get(key,node!.leftchild) }
        else if key > node!.key { return self._get(key,node!.rightchild) }

        return nil
    }

    func delete(key: A){
        guard self.size >= 1 else { return }

        if self.size == 1 {
            self.root = nil
            self.size -= 1
            return 
        }
        
        let item = self._get(key,self.root)
        if item != nil { self._delete(item) }
        self.size -= 1
    }

    func _delete(item: TreeNode<A,B>?){
        if item!.is_leaf() {
            if item!.is_leftchild(){
                item!.parent!.leftchild = nil
            } else if item!.is_rightchild() {
                item!.parent!.rightchild = nil
            }            
        } else if item!.has_bothchild() {
            let _item = item!.find_successor()
            _item!.spliceout()
            item!.key = _item!.key
            item!.value = _item!.value
            
        } else if item!.has_leftchild() {
            if item!.is_leftchild() {
                item!.leftchild!.parent = item!.parent
                item!.parent!.leftchild = item!.leftchild                
            } else if item!.is_rightchild(){
                item!.leftchild!.parent = item!.parent
                item!.parent!.rightchild = item!.rightchild
            } else {
                item!.replace_nodedata(item!.leftchild!.key,item!.leftchild!.value,item!.leftchild!.leftchild,item!.leftchild!.rightchild)
            }
        } else if item!.has_rightchild(){
            if item!.is_rightchild(){
                item!.rightchild!.parent = item!.parent
                item!.parent!.rightchild = item!.rightchild
            } else if item!.is_leftchild(){
                item!.rightchild!.parent = item!.parent
                item!.parent!.leftchild = item!.leftchild
            } else {
                item!.replace_nodedata(item!.rightchild!.key,item!.rightchild!.value,item!.rightchild!.leftchild,item!.rightchild!.rightchild)
            }
        }
        
    }
}


