extension String {
    
    public func minimumEditDistance(other: String) -> Int {
        let m = self.characters.count
        let n = other.characters.count
        var matrix = [[Int]](count: m+1, repeatedValue: [Int](count: n+1, repeatedValue: 0))
        
        for index in 1...m {
            matrix[index][0]=index
        }
        for index in 1...n {
            matrix[0][index]=index
        }
        
        for (i, selfChar) in self.characters.enumerate() {
            for (j, otherChar) in other.characters.enumerate() {
                if otherChar == selfChar {
                    matrix[i+1][j+1] = matrix[i][j]
                } else {
                    matrix[i+1][j+1] = min(matrix[i][j]+1, matrix[i+1][j]+1, matrix[i][j+1]+1)
                }
                
            }
        }
        return matrix[m][n]
    }
}
