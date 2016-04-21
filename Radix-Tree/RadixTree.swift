import Foundation


public class RadixNode {
	public var parent: RadixNode?
	public var children = [(childNode: RadixNode, childEdgeLabel: String)]()

	public init() {

	}

	public init(value: String) {
		self.children.append((childNode: RadixNode(), childEdgeLabel: value))
	}

	public func addChild(_ node: RadixNode, _ label: String) {
		children.append((node, label))
		node.parent = self
	}

	public func getChildren() -> [(childNode: RadixNode, childEdgeLabel: String)] {
		return children
	}

	public func getChildAt(i: Int) -> (RadixNode, String)? {
		if i >= children.count {
			return nil
		}
		return children[i]
	}

	public func getParent() -> RadixNode? {
		return parent
	}

	public func isLeaf() -> Bool {
		return children.count == 0
	}
}

public class RadixTree {
	public var root: RadixNode

	//Construct an "empty" RadixTree with a single node
	public init() {
		root = RadixNode()
	}

	public init(value: String) {
		self.root = RadixNode(value: value)
	}

	public func find(str: String, node: RadixNode?) -> Bool {
		var currNode: RadixNode
		var search = str
		if (node == nil) {
			currNode = self.root
		}
		else {
			currNode = node!
		}
		if (str == "") {
			return true
		} 
		else {
			for n in 0...currNode.children.count-1 {
				if (str.hasPrefix(currNode.children[n].childEdgeLabel)) {
					let elementsFound = currNode.children[n].childEdgeLabel.characters.count
					search = search.substringFromIndex(search.startIndex.advanced(by: elementsFound))
					currNode = currNode.children[n].childNode
					find(str: search, node: currNode)
				}
			}
		}
		return false
	}

	public func insert(str: String, node: RadixNode?) -> Bool {
		var search = str
		var currNode: RadixNode
		if (node == nil) {
			currNode = self.root
		}
		else {
			currNode = node!
		}
		//Case 0: str == "" (it is already in the tree)
		//			-> return false
		if (str == "") {
			return false
		}
		else {
			for c in currNode.children {

			//Temp is the string of the prefix that the label and the
			//  search string have in common.
			//let temp = currNode.children[c].childEdgeLabel.sharePrefix(str)

			//Case 3: currNode has a child that shares some prefix with str
			//			-> little bit more complicated
			//if temp == 0 {

				//Remove the shared characters from both the search string and
				//  label
				//currNode.children[c].childEdgeLabel.substringFromIndex(temp.count)
				//str.substringFromIndex(temp.count)


			//}
			

			//Case 1: currNode has no children that share a prefix with str
			//			-> create a new child for currNode		


			//Case 2: currNode has a child whose label is a prefix of str
			//			-> recurse down

			}
		}
		return false
	}
}