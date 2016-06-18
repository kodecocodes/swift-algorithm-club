//
//  TernarySearchTree.swift
//
//
//  Created by Siddharth Atre on 3/15/16.
//
//

import Foundation


public class TernarySearchTree<Element> {

    var root: TSTNode<Element>?

    public init() {}

    //MARK: - Insertion

    public func insert(data: Element, withKey key: String) -> Bool {
        return insertNode(&root, withData: data, andKey: key, atIndex: 0)

    }

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


    public func find(key: String) -> Element? {
        return findNode(root, withKey: key, atIndex: 0)
    }


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
