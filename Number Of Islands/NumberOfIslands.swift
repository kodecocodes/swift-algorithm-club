import Foundation
func numOfIslands(_ grid: [[Character]]) -> Int {
    guard grid.count > 0 else { return 0 }
    guard grid[0].count > 0 else { return 0 }
    var grid = grid
    var islandCounter = 0
    for i in 0..<grid.count{
        for j in 0..<grid[i].count{
            if grid[i][j] == "1"{
                islandCounter += 1
                landSink(&grid, i, j)
            }
        }
    }
    return islandCounter
}
func landSink(_ grid : inout [[Character]], _ i : Int, _ j : Int){
    if i >= 0 && j >= 0 && i < grid.count && j < grid[i].count && grid[i][j] == "1" {
        grid[i][j] = "0"
        landSink(&grid, i+1, j)
        landSink(&grid, i-1, j)
        landSink(&grid, i, j+1)
        landSink(&grid, i, j-1)
    }
    else{
        return
    }
}
