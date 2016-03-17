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
    var key: String
    var data: Element?
    var isKey: Bool
    
    //Children
    var left: TSTNode?, right: TSTNode?, middle: TSTNode?
    
    
    init(key: String, data: Element?) {
        self.key = key
        self.data = data
        self.isKey = (data != nil)
    }
    
    init(key:String) {
        self.key = key
        self.data = nil
        self.isKey = false
    }
    
}