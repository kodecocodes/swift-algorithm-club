//: Playground - noun: a place where people can play

// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

extension String {
    func indexOf(_ pattern : String) -> String.Index? {
        let noOfLoops = self.count - pattern.count + 1
        for i in 0..<noOfLoops{
            for (index,char) in pattern.enumerated(){
                if char == Array(self)[i + index] {
                    if char == pattern.last{
                        return self.index(self.startIndex, offsetBy: i)
                    }
                }else{
                    break
                }
            }
        }
        return nil
    }

}

// A few simple tests

let s = "Hello, World"
s.indexOf("World")  // 7

let animals = "🐶🐔🐷🐮🐱"
animals.indexOf("🐮")  // 3
