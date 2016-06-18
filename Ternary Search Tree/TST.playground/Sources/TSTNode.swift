//
//  TSTNode.swift
//
//
//  Created by Siddharth Atre on 3/15/16.
//
//

import Foundation

class TSTNode<Element> {
    //Member properties of a particular node.
    var key: Character
    var data: Element?
    var hasData: Bool

    //Children
    var left: TSTNode?, right: TSTNode?, middle: TSTNode?


    init(key: Character, data: Element?) {
        self.key = key
        self.data = data
        self.hasData = (data != nil)
    }

    init(key: Character) {
        self.key = key
        self.data = nil
        self.hasData = false
    }

}
