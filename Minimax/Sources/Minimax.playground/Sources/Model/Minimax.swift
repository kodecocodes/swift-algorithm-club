import Foundation
    
public func evaluatePosition(board: Board, player: Player, opponent: Player) -> Int {
    if board.check(player: player) == BoardStatus.win {
        return +10
    }
    else if board.check(player: opponent) == BoardStatus.win {
        return -10
    }
    else if board.check(player: player) == BoardStatus.draw || board.check(player: opponent) == BoardStatus.draw {
        return 0
    }
    
    return 1
}

public func minMax(board: Board, player: Player, opponent: Player, depth: Int, alpha: Int, beta: Int, maximizingPlayer: Bool) -> Int {
    var alpha = alpha
    var beta = beta
    
    let gameResult = evaluatePosition(board: board, player: player, opponent: opponent)
    guard depth != 0 && gameResult != -10 && gameResult != 10 && gameResult != 0 else {
        return gameResult
    }
    
    if maximizingPlayer {
        var maxEval = -Int.max
        
        for i in 0...board.size-1 {
            for j in 0...board.size-1 {
                if board.table[i][j] == "0" {
                    var tempBoard = board
                    tempBoard.makeMove(player: player, position: (i,j))
                    let eval = minMax(board: tempBoard, player: player, opponent: opponent, depth: depth-1, alpha: alpha, beta: beta, maximizingPlayer: !maximizingPlayer)
                    maxEval = max(maxEval, eval)
                    alpha = max(alpha, eval)
                    
                    if beta <= alpha {
                        break
                    }
                }
            }
        }
        return maxEval
    }
    else {
        var minEval = Int.max
        
        for i in 0...board.size-1 {
            for j in 0...board.size-1 {
                if board.table[i][j] == "0" {
                    var tempBoard = board
                    tempBoard.makeMove(player: opponent, position: (i,j))
                    let eval = minMax(board: tempBoard, player: player, opponent: opponent, depth: depth-1, alpha: alpha, beta: beta, maximizingPlayer: !maximizingPlayer)
                    minEval = min(minEval, eval)
                    beta = min(beta, eval)
                    
                    if beta <= alpha {
                        break
                    }
                }
            }
        }
        return minEval
    }
}

public func minMaxMove(board: Board, player: Player, opponent: Player, depth: Int) -> (Int, Int) {
    var bestVal = -10
    var bestMoves: [(Int, Int)] = []
    
    for i in 0...board.size-1 {
        for j in 0...board.size-1 {
            if board.table[i][j] == "0" {
                var tempBoard = board
                let move = (i, j)
                
                tempBoard.makeMove(player: opponent, position: (i, j))
                let moveVal = minMax(board: tempBoard, player: opponent, opponent: player, depth: depth, alpha: -10, beta: 10, maximizingPlayer: false)
                
                if moveVal > bestVal {
                    bestVal = moveVal
                    bestMoves = []
                    bestMoves.append(move)
                }
                else if moveVal == bestVal {
                    bestMoves.append(move)
                }
            }
        }
    }
    
    return bestMoves[Int.random(in: 0...bestMoves.count-1)]
}
