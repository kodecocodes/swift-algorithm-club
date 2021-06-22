import Foundation

public class GameModelAI: GameModel {
    var searchingDepth: Int = 5
    
    override init(boardSize: Int, playersList: [Player]) {
        super.init(boardSize: boardSize, playersList: playersList)
    }
    
    public func makeMoveAI() {
        guard actualPlayer.name == "Computer" else {
            return
        }
        
        let selectedPosition: (column: Int, row: Int) = minMaxMove(board: board, player: playersList[0], opponent: playersList[1], depth: searchingDepth)
        guard board.table[selectedPosition.column][selectedPosition.row] == "0" else {
            return
        }
        
        board.makeMove(player: actualPlayer, position: selectedPosition)
        update()
    }
}
