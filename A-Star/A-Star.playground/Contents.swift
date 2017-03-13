
import Foundation
//⚪️ - free point
//⚫️ - busy point
//🔴 - start point
//🔵 - end point

let testData = ["⚪️","⚪️","⚪️","⚪️","⚪️","⚪️","⚪️",
                "⚪️","⚫️","⚪️","⚫️","⚪️","⚫️","⚪️",
                "⚪️","⚫️","⚪️","⚫️","🔵","⚫️","⚪️",
                "⚪️","⚪️","⚪️","⚫️","⚫️","⚪️","⚪️",
                "🔴","⚫️","⚪️","⚪️","⚪️","⚪️","⚪️"]


var starPoints = [ASNode]()

var startPoint: ASNode!
var endPoint: ASNode!

for x in 0..<7 {
    for y in 0..<5 {
        let symbol = testData[y*7+x]
        let node = ASNode.init(at: x, pointY: y)
        switch symbol {
        case "🔴":
            startPoint = node
            break
        case "🔵":
            endPoint = node
            break
        case "⚫️":
            node.type = .busy
            break
        default:
            break
        }
        starPoints.append(node)
    }
}

if let path = AStar.find(startPoint: startPoint, endPoint: endPoint, nodes: starPoints, diagonally: false) {
    for y in 0..<5 {
        for x in 0..<7 {
            var symbol = testData[y*7+x]
            for item in path {
                if item.x == x && item.y == y {
                    symbol = "🔶"
                }
            }
            print(symbol, terminator: " ")
        }
        print("\n")
    }
} else {
    print("Can't find path")
}

