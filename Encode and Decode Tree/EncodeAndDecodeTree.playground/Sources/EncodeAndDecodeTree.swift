//
//  EncodeAndDecodeTree.swift
//  
//
//  Created by Kai Chen on 19/07/2017.
//
//

import Foundation

public class TreeNode {
    public var val: String
    public var left: TreeNode?
    public var right: TreeNode?

    public init(_ val: String, left: TreeNode? = nil, right: TreeNode? = nil) {
        self.val = val
        self.left = left
        self.right = right
    }
}

public class EncodeAndDecodeTree {
    private var encodeStr = ""
    private var ret: [String] = []

    public init() {}

    public func encode(_ root: TreeNode?) -> String {
        encodeIt(root)

        return encodeStr
    }

    public func decode(_ data: String) -> TreeNode? {
        var s = data
        while (s.contains(" ")) {
            let index = s.index(of: " ")
            let endIndex = s.index(before: index)
            let element = s[s.startIndex...endIndex]
            ret.append(element)
            let range = ClosedRange(uncheckedBounds: (lower: s.startIndex, upper: index))
            s.removeSubrange(range)
        }

        if ret.count == 0 {
            return nil
        }

        var dep = 0
        let root = decodeIt(&dep)

        return root
    }

    private func getNode(_ element: String) -> TreeNode? {
        if element == "#" {
            return nil
        }

        return TreeNode(element)
    }

    private func decodeIt(_ dep: inout Int) -> TreeNode? {
        guard let currentNode = getNode(ret[dep]) else {
            return nil
        }

        dep += 1
        let left = decodeIt(&dep)
        dep += 1
        let right = decodeIt(&dep)

        currentNode.left = left
        currentNode.right = right

        return currentNode
    }

    private func encodeIt(_ root: TreeNode?) {
        guard let root = root else {
            encodeStr += "# "
            return
        }

        encodeStr += root.val + " "
        encodeIt(root.left)
        encodeIt(root.right)
    }
}

extension String {
    func index(of target: Character) -> String.Index {
        var i = 0
        for c in self.characters {
            if c == target {
                return self.index(self.startIndex, offsetBy: i)
            }
            i += 1
        }

        return self.endIndex
    }
}
