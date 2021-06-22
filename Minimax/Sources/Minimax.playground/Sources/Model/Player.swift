import Foundation

/*
enum PlayerSymbol: Int {
    case Null
    case Circle
    case Cross
}*/

public typealias PlayerSymbol = String

public struct Player {
    var name: String
    var symbol: PlayerSymbol
    var points = 0
    
    public init(name: String, symbol: PlayerSymbol) {
        self.name = name
        self.symbol = symbol
    }
}
