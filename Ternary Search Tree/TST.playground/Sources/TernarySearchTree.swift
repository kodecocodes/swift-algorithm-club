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

    // MARK: - Insertion

    public func insert(data: Element, withKey key: String) -> Bool {
        return insert(node: &root, withData: data, andKey: key, atIndex: 0)
    }

    private func insert(node: inout TSTNode<Element>?, withData data: Element, andKey key: String, atIndex charIndex: Int) -> Bool {

        //sanity check.
        if key.characters.count == 0 {
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

    // MARK: - Finding

    public func find(key: String) -> Element? {
        return find(node: root, withKey: key, atIndex: 0)
    }

    private func find(node: TSTNode<Element>?, withKey key: String, atIndex charIndex: Int) -> Element? {

        //Given key does not exist in tree.
        if node == nil {
            return nil
        }

        let index = key.index(key.startIndex, offsetBy: charIndex)
        //go left
        if key[index] < node!.key {
            return find(node: node!.left, withKey: key, atIndex: charIndex)
        }
            //go right
        else if key[index] > node!.key {
            return find(node: node!.right, withKey: key, atIndex: charIndex)
        }
            //go middle
        else {
            if charIndex + 1 < key.characters.count {
                return find(node: node!.middle, withKey: key, atIndex: charIndex + 1)
            } else {
                return node!.data
            }
        }
    }
}
