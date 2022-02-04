/*
  Brute-force string search
*/
extension String {
  func indexOf(_ pattern : String) -> String.Index? {
    let noOfLoops = self.count - pattern.count + 1
    for i in 0..<noOfLoops {
      for (index,char) in pattern.enumerated() {
        if char == Array(self)[i + index] {
          if index == pattern.count - 1 {
            //Pattern found in the string
            return self.index(self.startIndex, offsetBy: i)
          }
        } else {
          break
        }
      }
    }
    return nil
  }
}
