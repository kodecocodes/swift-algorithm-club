import Foundation

class Root {

	var children: [Edge]

	init() {
		children = [Edge]()
	}

	func height() -> Int {
		if children.count == 0 {
			return 1
		}
		else {
			var max = 1
			for c in children {
				if c.height() > max {
					max = c.height()
				}
			}
			return 1 + max
		}
	}

	func level() -> Int {
		return 0
	}

	func printRoot() {
		//print("children: \(children.count)")
		//print("split at: \(children.count/2-1)")
		if (children.count > 1) {
			for c in 0...children.count/2-1 {
				children[c].printEdge()
				print("|")
			}
		}
		else if children.count > 0 {
			children[0].printEdge()
		}
		print("ROOT")
		//print("second half starts at: \(children.count/2)")
		if children.count > 1 {
			for c in children.count/2...children.count-1 {
				children[c].printEdge()
				print("|")
			}
		}
		print()
	}
}

class Edge: Root {

	var parent: Root?
	var label: String

	init(_ label: String) {	//Edge(label: "label")
		self.label = label
		super.init()
	}

	override
	func level() -> Int {
		if parent != nil {
			return 1 + parent!.level()
		}
		else {
			return 1
		}
	}

	func erase() {
		print("Testing erase on: \(label)")
		self.parent = nil
		if children.count > 0 {
			for _ in 0...children.count-1 {
				children[0].erase()
				children.remove(at: 0)
			}
		}
		print("Removed: \(label)")
	}

	func printEdge() {
		if children.count > 1 {
			for c in 0...children.count/2-1 {
				children[c].printEdge()
			}
		}
		else if children.count > 0 {
			children[0].printEdge()
		}
		for x in 1...level() {
			if x == level() {
				print("|------>", terminator: "")
			}
			else if x == 1 {
				print("|       ", terminator: "")
			}
			else if x == level()-1 {
				print("|       ", terminator: "")
			}
			else {
				print("|       ", terminator: "")
			}
		}
		print(label)
		if children.count == 0 {
			for _ in 1...level() {
				print("|       ", terminator: "")
			}
			print()
		}
		if children.count > 1 {
			for c in children.count/2...children.count-1 {
				children[c].printEdge()
			}
		}
	}
}

class RadixTree {

	var root: Root

	init() {
		root = Root()
	}

	func height() -> Int {
		return root.height() - 1
	}

	func insert(_ str: String) -> Bool {
		//Account for a blank input
		if str == "" {
			return false
		}
		//Account for an empty tree
		if root.children.count == 0 {
			root.children.append( Edge(str) )
			return true
		}
		var searchStr = str
		var currEdge = root
		while (true) {
			var found = false
			if currEdge.children.count == 0 {
				let newEdge = Edge(searchStr)
				currEdge.children.append(newEdge)
				newEdge.parent = currEdge
			}
			for e in currEdge.children {
				//Get the shared 
				var shared = sharedPrefix(searchStr, e.label)
				var index  = shared.startIndex
				//The search string is equal to the shared string
				//so the string already exists in the tree
				if searchStr == shared {
					return false
				}
				else if shared == e.label {
					currEdge = e
					var tempIndex = searchStr.startIndex
					for _ in 1...shared.characters.count {
						tempIndex = tempIndex.successor()
					}
					searchStr = searchStr.substringFromIndex(tempIndex)
					found = true
					break
				}
				//The child's label and the search string share a prefix
				else if shared.characters.count > 0 {
					//Cut the prefix off from both the search string and label
					var labelIndex = e.label.characters.startIndex
					//Create index objects and move them to after the shared prefix
					for _ in 1...shared.characters.count {
						index = index.successor()
						labelIndex = labelIndex.successor()
					}
					//Substring both the search string and the label from the shared prefix
					searchStr = searchStr.substringFromIndex(index)
					e.label = e.label.substringFromIndex(labelIndex)
					//Create 2 new edges and update parent/children values
					let newEdge = Edge(e.label)
					e.label = shared
					for ec in e.children {
						newEdge.children.append(ec)
					}
					newEdge.parent = e
					e.children.removeAll()
					for nec in newEdge.children {
						nec.parent = newEdge
					}
					e.children.append(newEdge)
					let newEdge2 = Edge(searchStr)
					newEdge2.parent = e
					e.children.append(newEdge2)
					return true
				}
				//They don't share a prefix (go to next child)
			}
			if (!found) {
				//No children share a prefix, so create a new child
				let newEdge = Edge(searchStr)
				currEdge.children.append(newEdge)
				newEdge.parent = currEdge
				return true
			}
		}
	}

	func find(_ str: String) -> Bool {
		//A radix tree always contains the empty string
		if str == "" {
			return true
		}
		//If there are no children then the string cannot be in the tree
		else if root.children.count == 0 {
			return false
		}
		var searchStr = str
		var currEdge = root
		while (true) {
			var found = false
			for c in currEdge.children {
				//First check if the search string and the child's label are equal
				//  if so the string is in the tree, return true
				if searchStr == c.label {
					return true
				}
				//If that is not true, find the shared string b/t the search string
				//  and the label
				var shared = sharedPrefix(searchStr, c.label)
				//If the shared string is equal to the label, update the curent node
				//  and run it back
				if shared == c.label {
					currEdge = c
					var tempIndex = searchStr.startIndex
					for _ in 1...shared.characters.count {
						tempIndex = tempIndex.successor()
					}
					searchStr = searchStr.substringFromIndex(tempIndex)
					found = true
					break
				}
				//If the shared string is empty, go to the next children
				else if shared.characters.count == 0 {
					continue
				}
				//If the shared string matches the search string, return true
				else if shared == searchStr {
					return true
				}
				//If the search string and the child's label only share some characters,
				//  the string is not in the tree, return false
				else if shared[shared.startIndex] == c.label[c.label.startIndex] &&
				  shared.characters.count < c.label.characters.count {
				  	return false
				}
			}
			if !found {
				return false
			}
		}
	}

	func remove(_ str: String) -> Bool {
		print("Tryna remove: \(str)")
		//You cannot remove the empty string from the tree
		if str == "" {
			return false
		}
		//If the tree is empty, you cannot remove anything
		else if root.children.count == 0 {
			return false
		}
		var searchStr = str
		var currEdge = root
		while (true) {
			var found = false
			print("Search string: \(searchStr)")
			//If currEdge has no children, then the searchStr is not in the tree
			if currEdge.children.count == 0 {
				return false
			}
			for c in 0...currEdge.children.count-1 {
				//If the child's label matches the search string, remove that child
				//  and everything below it in the tree
				print("Looking at: \(currEdge.children[c].label)")
				if currEdge.children[c].label == searchStr {
					print("MATCH FOUND")
					currEdge.children[c].erase()
					print("ERASED WORKED")
					currEdge.children.remove(at: c)
					print("EDGE LABEL MATCH REMOVE")
					return true
				}
				//Find the shared string
				var shared = sharedPrefix(searchStr, currEdge.children[c].label)
				//If the shared string is equal to the child's string, go down a level
				if shared == currEdge.children[c].label {
					currEdge = currEdge.children[c]
					var tempIndex = searchStr.startIndex
					for _ in 1...shared.characters.count {
						tempIndex = tempIndex.successor()
					}
					searchStr = searchStr.substringFromIndex(tempIndex)
					found = true
					break
				}
			}
			//If there is no match, then the searchStr is not in the tree
			if !found {
				return false
			}
		}
	}

	func printTree() {
		root.printRoot()
	}
}

//Returns the prefix that is shared between the two input strings
//i.e. sharedPrefix("court", "coral") -> "co"
func sharedPrefix(_ str1: String, _ str2: String) -> String {
	var temp = ""
	var c1 = str1.characters.startIndex
	var c2 = str2.characters.startIndex
	for _ in 0...min(str1.characters.count-1, str2.characters.count-1) {
		if str1[c1] == str2[c2] {
			temp.append( str1[c1] )
			c1 = c1.successor()
			c2 = c2.successor()
		}
		else {
			return temp
		}
	}
	return temp
}