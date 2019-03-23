import Foundation

let xTrain = [[1.0, 1.0], [2.0, 2.0], [2.0, 3.0], [3.0, 4.0], [3.0, 6.0], [4.0, 5.0]]
let yTrain = [1, 1, 1, 2, 2, 2]
let xTest = [[4.0, 6.0], [1.0, 2.0]]

let model = KNearestNeighbors(xTrain, yTrain)

let yTest = model.predict(xTest) // [2, 1]
