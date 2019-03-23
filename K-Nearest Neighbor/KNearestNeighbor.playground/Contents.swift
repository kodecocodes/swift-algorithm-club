import Foundation

var str = "Hello, playground"

let data: [[Double]] = [[1, 1], [2.0, 2.0], [2.0, 3.0], [3.0, 4.0], [3.0, 6.0], [4.0, 5.0]]
let labels = [1, 1, 1, 2, 2, 2]
let test = [[1, 1], [2.0, 2.0], [2.0, 3.0], [3.0, 4.0], [3.0, 6.0], [4.0, 5.0]]

let model = KNearestNeighbors(data, labels)
var res = model.predict(test)
assert(res == labels)
