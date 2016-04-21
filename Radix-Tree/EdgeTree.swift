class Root {

	var children: [Edge]

	init() {
		children = [Edge]()
	}

}

class Edge: Root {

	var parent: Edge?
	var label: String

	init(_ label: String) {
		self.label = label
		super.init()
	}

}

class EdgeTree {

	var root: Root

	init() {
		root = Root()
	}

	func insert(_ str: String) -> Bool {

		//Account for a blank input
		if str == "" {
			return true
		}

		//Account for an empty tree
		if root.children.count == 0 {
			root.children.append( Edge(str) )
			return true
		}

		var searchStr = str
		var currEdge = root

		while (true) {

			var i = 0

			for e in currEdge.children {

				//Get the shared 
				var shared = sharedPrefix(searchStr, e.label)
				var index  = shared.startIndex

				//The search string is equal to the shared string
				//so the string already exists in the tree
				if searchStr == shared {
					return false
				}

				//The child's label is a prefix of the search string
				else if e.label.hasPrefix(shared) {

					for _ in 1...shared.characters.count {
						index = index.successor()
					}

					//Substring the search string so that the prefix is removed
					searchStr = searchStr.substringFromIndex(index)

					//Set currNode to e
					currEdge = e
					break

				}


				//The child's label and the search string share a prefix
				else if shared.characters.count > 0 {

					//Cut the prefix off from both the search string and label
					var labelIndex = e.label.characters.startIndex

					for _ in 1...shared.characters.count {
						index = index.successor()
						labelIndex = labelIndex.successor()
					}

					searchStr = searchStr.substringFromIndex(index)
					e.label = e.label.substringFromIndex(labelIndex)

					//Create a new edge whose label is the shared string
					//its parent is currEdge.parent and add a child with
					//label = searchStr
					//Also add it to the parent's children
					let newEdge = Edge(shared)
					newEdge.children.append( Edge(searchStr) )
					newEdge.parent = e.parent
					currEdge.children.append(newEdge)

					//Remove this edge from the parent's child list
					currEdge.children.remove(at: i)

					//Set this edge's parent to the prefix node
					e.parent = newEdge.parent
					return true

				}

				//They don't share a prefix (go to next child)
				i += 1

			}

			//No children share a prefix, so create a new child
			currEdge.children.append( Edge(searchStr) )
			return true
		}
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