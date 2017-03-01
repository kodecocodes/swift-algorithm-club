//
//  TernarySearchTree.swift
//
//
//  Created by Siddharth Atre on 3/15/16.
//
//

import Foundation

/**
The Ternary Search Tree (TST) Data structure.
Data structure uses key-value mappings. Keys are strings used to map to any data element.
See README for more information.
*/
public class TernarySearchTree<Element> {

    /// A reference to the root node of this TST
    var root: TSTNode<Element>?

    /**
     Standard initializer
     */
    public init() {}

    //MARK: - Insertion

    /**
    Public insertion method.

    - parameter data: The value to store in this TST.
    - parameter key:  The key to associate with this value.

    - returns: Value indicating insertion success/failure.
    */
    @discardableResult public func insert(data: Element, withKey key: String) -> Bool {
        return insert(node: &root, withData: data, andKey: key, atIndex: 0)
    }

    /**
     Helper method for insertion that does the actual legwork. Insertion is performed recursively.

     - parameter node:      The current node to insert below.
     - parameter data:      The data being inserted.
     - parameter key:       The key being used to find an insertion location for the given data
     - parameter charIndex: The index of the character in the key string to use to for the next node.

     - returns: Value indicating insertion success/failure.
     */
    private func insert(node: inout TSTNode<Element>?, withData data: Element, andKey key: String, atIndex charIndex: Int) -> Bool {

        //sanity check.
        guard key.characters.count > 0 else {
            return false
        }

        //create a new node if necessary.
        if node == nil {
            let index = key.index(key.startIndex, offsetBy: charIndex)
            node = TSTNode<Element>(key: key[index])
        }

        //if current char is less than the current node's char, go left
        let index = key.index(key.startIndex, offsetBy: charIndex)
        if key[index] < node!.key {
            return insert(node: &node!.left, withData: data, andKey: key, atIndex: charIndex)
        }
            //if it's greater, go right.
        else if key[index] > node!.key {
            return insert(node: &node!.right, withData: data, andKey: key, atIndex: charIndex)
        }
            //current char is equal to the current nodes, go middle
        else {
            //continue down the middle.
            if charIndex + 1 < key.characters.count {
                return insert(node: &node!.middle, withData: data, andKey: key, atIndex: charIndex + 1)
            }
            //otherwise, all done.
            else {
                node!.data = data
                node?.hasData = true
                return true
            }
        }
    }


    //MARK: - Finding

    /**
    Public find method.

    - parameter key: Search for an object associated with this key.

    - returns: The element, if found. Otherwise, nil.
    */
    public func find(key: String) -> Element? {
        return find(node: root, withKey: key, atIndex: 0)
    }

    /**
     Helper method that performs actual legwork of find operation. Implemented recursively.

     - parameter node:      The current node being evaluated.
     - parameter key:       The key being used for the search.
     - parameter charIndex: The index of the current char in the search key

     - returns: The element, if found. Nil otherwise.
     */
    private func find(node: TSTNode<Element>?, withKey key: String, atIndex charIndex: Int) -> Element? {

        //Given key does not exist in tree.
        guard let node = node else {
            return nil
        }

        let index = key.index(key.startIndex, offsetBy: charIndex)
        //go left
        if key[index] < node.key {
            return find(node: node.left, withKey: key, atIndex: charIndex)
        }
            //go right
        else if key[index] > node.key {
            return find(node: node.right, withKey: key, atIndex: charIndex)
        }
            //go middle
        else {
            if charIndex + 1 < key.characters.count {
                return find(node: node.middle, withKey: key, atIndex: charIndex + 1)
            } else {
                return node.data
            }
        }
    }
}
