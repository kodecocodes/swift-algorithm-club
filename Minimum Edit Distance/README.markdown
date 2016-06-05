# Minimum Edit Distance

The minimum edit distance is a possibility to measure the similarity of two strings *w* and *u* by counting costs of operations which are necessary to transform *w* into *u* (or vice versa).

### Algorithm using Levenshtein distance

A common distance measure is given by the *Levenshtein distance*, which allows the following three transformation operations:

* **Inseration** (*ε→x*) of a single symbol *x* with **cost 1**,
* **Deletion** (*x→ε*) of a single symbol *x* with **cost 1**, and
* **Substitution** (*x→y*) of two single symbols *x, y* with **cost 1** if *x≠y* and with **cost 0** otherwise.

When transforming a string by a sequence of operations, the costs of the single operations are added to obtain the (minimal) edit distance. For example, the string *Door* can be transformed by the operations *o→l*, *r→l*, *ε→s* to the string *Dolls*, which results in a minimum edit distance of 3.

To avoid exponential time complexity, the minimum edit distance of two strings in the usual is computed using *dynamic programming*. For this in a matrix

```swift
var matrix = [[Int]](count: m+1, repeatedValue: [Int](count: n+1, repeatedValue: 0))
```

already computed minimal edit distances of prefixes of *w* and *u* (of length *m* and *n*, respectively) are used to fill the matrix. In a first step the matrix is initialized by filling the first row and the first column as follows:

```swift
// initialize matrix
for index in 1...m {
    // the distance of any prefix of the first string to an empty second string
    matrix[index][0]=index
}
for index in 1...n {
    // the distance of any prefix of the second string to an empty first string
    matrix[0][index]=index
}
```
Then in each cell the minimum of the cost of insertion, deletion, or substitution added to the already computed costs in the corresponding cells is chosen. In this way the matrix is filled iteratively:

```swift
// compute Levenshtein distance
for (i, selfChar) in self.characters.enumerate() {
    for (j, otherChar) in other.characters.enumerate() {
        if otherChar == selfChar {
            // substitution of equal symbols with cost 0
            matrix[i+1][j+1] = matrix[i][j]
        } else {
            // minimum of the cost of insertion, deletion, or substitution added 
            // to the already computed costs in the corresponing cells
            matrix[i+1][j+1] = min(matrix[i][j]+1, matrix[i+1][j]+1, matrix[i][j+1]+1)
        }
                
    }
}
```

After applying this algorithm, the minimal edit distance can be read from the rightmost bottom cell and is returned.

```swift
return matrix[m][n]
```

This algorithm has a time complexity of Θ(*mn*).

### Other distance measures

**todo**

*Written for Swift Algorithm Club by Luisa Herrmann*