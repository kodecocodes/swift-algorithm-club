import Foundation



func prims (_ matrix : [[Int]]) {
    var selected = 0
    var selectedSoFar = Set<Int>()
    selectedSoFar.insert( (matrix[selected].enumerated().min{ $0.element < $1.element }?.offset)! )

    while selectedSoFar.count < matrix.count {
        var minValue = Int.max
        var minIndex = selected
        var initialRow = 0
        for row in selectedSoFar {
            let candidateMin = matrix[row].enumerated().filter{$0.element > 0 && !selectedSoFar.contains($0.offset) }.min{ $0.element < $1.element }
            if (minValue > candidateMin?.element ?? Int.max ) {
                minValue = candidateMin?.element ?? Int.max
                minIndex = (candidateMin?.offset) ?? 0
                initialRow = row
            }
        }
        print ("edge value \(minValue) with \(initialRow) to \(minIndex)")
        selectedSoFar.insert(minIndex)
        selected = (minValue)
    }
}

let input = [[0,9,75,0,0],[9,0,95,19,42],[75,95,0,51,66],[0,19,51,0,31],[0,42,66,31,0]]
prims(input)

