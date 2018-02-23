//: Playground - noun: a place where people can play

// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

extension Array where Element: Equatable {
    func linearSearch(_ element: Element) -> Int? {
        for (index, candidate) in self.enumerated() {
            if candidate == element {
                return index
            }
        }
        return nil
    }
}

let array = [5, 2, 4, 7]
array.linearSearch(2)	// returns 1
array.linearSearch(3) 	// returns nil
