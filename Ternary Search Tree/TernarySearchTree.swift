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
    public func insert(data: Element, withKey key: String) -> Bool {
        return insertNode(&root, withData: data, andKey: key, atIndex: 0)
    }

    /**
     Helper method for insertion that does the actual legwork. Insertion is performed recursively.

     - parameter aNode:     The current node to insert below.
     - parameter data:      The data being inserted.
     - parameter key:       The key being used to find an insertion location for the given data
     - parameter charIndex: The index of the character in the key string to use to for the next node.

     - returns: Value indicating insertion success/failure.
     */
    private func insertNode(inout aNode: TSTNode<Element>?, withData data: Element, andKey key: String, atIndex charIndex: Int) -> Bool {

        //sanity check.
        if key.characters.count == 0 {
            return false
        }

        //create a new node if necessary.
        if aNode == nil {
            let index = key.startIndex.advancedBy(charIndex)
            aNode = TSTNode<Element>(key: key[index])
        }

        //if current char is less than the current node's char, go left
        let index = key.startIndex.advancedBy(charIndex)
        if key[index] < aNode!.key {
            return insertNode(&aNode!.left, withData: data, andKey: key, atIndex: charIndex)
        }
            //if it's greater, go right.
        else if key[index] > aNode!.key {
            return insertNode(&aNode!.right, withData: data, andKey: key, atIndex: charIndex)
        }
            //current char is equal to the current nodes, go middle
        else {
            //continue down the middle.
            if charIndex + 1 < key.characters.count {
                return insertNode(&aNode!.middle, withData: data, andKey: key, atIndex: charIndex + 1)
            }
                //otherwise, all done.
            else {
                aNode!.data = data
                aNode?.hasData = true
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
        return findNode(root, withKey: key, atIndex: 0)
    }

    /**
     Helper method that performs actual legwork of find operation. Implemented recursively.

     - parameter aNode:     The current node being evaluated.
     - parameter key:       The key being used for the search.
     - parameter charIndex: The index of the current char in the search key

     - returns: The element, if found. Nil otherwise.
     */
    private func findNode(aNode: TSTNode<Element>?, withKey key: String, atIndex charIndex: Int) -> Element? {

        //Given key does not exist in tree.
        if aNode == nil {
            return nil
        }

        let index = key.startIndex.advancedBy(charIndex)
        //go left
        if key[index] < aNode!.key {
            return findNode(aNode!.left, withKey: key, atIndex: charIndex)
        }
            //go right
        else if key[index] > aNode!.key {
            return findNode(aNode!.right, withKey: key, atIndex: charIndex)
        }
            //go middle
        else {
            if charIndex + 1 < key.characters.count {
                return findNode(aNode!.middle, withKey: key, atIndex: charIndex + 1)
            } else {
                return aNode!.data
            }
        }
    }
}
