import Foundation

public enum BoardStatus {
    
    case continues
    
    case win
    
    case draw
}

public struct Board {
    var table: [[String]] = []
    var size = 0
    
    init(size: Int) {
        self.size = size
        table = Array(repeating: Array(repeating: "0", count: size), count: size)
    }
    
    mutating func makeMove(player: Player, position: (column: Int, row: Int)) {
        let symbol = player.symbol
        table[position.column][position.row] = symbol
    }
    
    func check(player: Player) -> BoardStatus {
        let playerSymbol: String = player.symbol
        
        // Searching WIN in row's
        for i in 0...size-1 {
            var symbolsInRow = 0
            
            for j in 0...size-2 {
                if table[i][j] == table[i][j+1] && (table[i][j] == playerSymbol){
                    symbolsInRow += 1
                }
                else {
                    symbolsInRow = 0
                }
            }
            
            if symbolsInRow == size-1 {
                return BoardStatus.win
            }
        }
        
        // Searching WIN in column's
        for j in 0...size-1 {
            var symbolsInColumn = 0
            
            for i in 0...size-2 {
                if table[i][j] == table[i+1][j] && (table[i][j] == playerSymbol){
                    symbolsInColumn += 1
                }
                else {
                    symbolsInColumn = 0
                }
            }
            
            if symbolsInColumn == size-1 {
                return BoardStatus.win
            }
        }
        
        // Searching WIN in slant's
        var symbolsInSlant = 0
        
        for i in 0...size-1 {
            for j in -(size-1)...0 {
                if(table[-j][i] == playerSymbol){
                    var k: Int = -j
                    var l: Int = i
                    symbolsInSlant = 0
                    
                    while l < size && k >= 0 {
                        if table[k][l] == playerSymbol {
                            symbolsInSlant += 1
                        }
                        else {
                            symbolsInSlant = 0
                        }
                        k -= 1
                        l += 1
                        
                        if symbolsInSlant == size {
                            return BoardStatus.win
                        }
                    }
                    symbolsInSlant = 0
                }
                symbolsInSlant = 0
            }
            symbolsInSlant = 0
        }
        
        symbolsInSlant = 0
        
        for i in 0...size-1 {
            for j in 0...size-1 {
                if(table[j][i] == playerSymbol){
                    var k: Int = j
                    var l: Int = i
                    symbolsInSlant = 0
                    
                    while l < size && k < size {
                        if table[k][l] == playerSymbol {
                            symbolsInSlant += 1
                        }
                        else {
                            symbolsInSlant = 0
                        }
                        k += 1
                        l += 1
                        
                        if symbolsInSlant == size {
                            return BoardStatus.win
                        }
                    }
                    symbolsInSlant = 0;
                }
                symbolsInSlant = 0;
            }
            symbolsInSlant = 0;
        }
        
        // Searching not draw
        for i in 0...size-1 {
            for j in 0...size-1 {
                if table[i][j] == "0" {
                     return BoardStatus.continues
                }
            }
        }
        
        return BoardStatus.draw
    }
    
    mutating func clear() {
        table = Array(repeating: Array(repeating: "0", count: size), count: size)
    }
    
    func printBoard() {
        for row in table {
            for element in row {
                print(element, terminator: " ")
            }
            print(" ")
        }
    }
}
