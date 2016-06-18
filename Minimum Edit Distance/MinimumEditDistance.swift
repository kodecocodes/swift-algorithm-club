extension String {

    public func minimumEditDistance(other: String) -> Int {
        let m = self.characters.count
        let n = other.characters.count
        var matrix = [[Int]](count: m+1, repeatedValue: [Int](count: n+1, repeatedValue: 0))


        // initialize matrix
        for index in 1...m {
            // the distance of any first string to an empty second string
            matrix[index][0]=index
        }
        for index in 1...n {
            // the distance of any second string to an empty first string
            matrix[0][index]=index
        }

        // compute Levenshtein distance
        for (i, selfChar) in self.characters.enumerate() {
            for (j, otherChar) in other.characters.enumerate() {
                if otherChar == selfChar {
                    // substitution of equal symbols with cost 0
                    matrix[i+1][j+1] = matrix[i][j]
                } else {
                    // minimum of the cost of insertion, deletion, or substitution added to the already computed costs in the corresponding cells
                    matrix[i+1][j+1] = min(matrix[i][j]+1, matrix[i+1][j]+1, matrix[i][j+1]+1)
                }

            }
        }
        return matrix[m][n]
    }
}
