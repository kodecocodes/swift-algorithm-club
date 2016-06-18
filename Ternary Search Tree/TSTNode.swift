//
//  TSTNode.swift
//
//
//  Created by Siddharth Atre on 3/15/16.
//
//

import Foundation

/**
 This class represents a node in the Ternary Search Tree.
 A node has two main data members, the key and the data.
 All nodes in a TST must have keys, but only some will have data.
 This can be seen in the way the data variable is of Optional type.
*/
class TSTNode<Element> {
    //Member properties of a particular node.

    /// The key that identifies this node.
    var key: Character
    /// The data stored in this node. May be `nil`
    var data: Element?
    /// Boolean flag to depict whether this node holds data or not.
    var hasData: Bool

    /// The children of this node
    var left: TSTNode?, right: TSTNode?, middle: TSTNode?

    /**
     Initializer for key and/or data

     - parameter key:  The key to set for this node.
     - parameter data: The optional data to set in this node.
     */
    init(key: Character, data: Element?) {
        self.key = key
        self.data = data
        self.hasData = (data != nil)
    }

    /**
     Make a node that only has a key

     - parameter key: The key to ascribe to this node.
     */
    init(key: Character) {
        self.key = key
        self.data = nil
        self.hasData = false
    }

}
