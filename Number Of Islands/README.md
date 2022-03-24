# Number Of Islands
You have been given a 2D matrix representing an area containing land and water represented by 1 and 0 respectively. Your task is to return the total number of islands present in the total area. An island is surrounded by water and is formed by connecting adjacent lands horizontally or vertically. Assume that edges of the matrix are surrounded by water.

## Example:
```
Area :[["1","1","1","1","0"],
       ["1","1","0","1","0"],
       ["1","1","0","0","0"],
       ["0","0","0","0","0"]]

Solution : 1
```
### Explanation:
As all the 1's are adjacent to each other either horizontally or vertically, they form only one single island. Hence the solution for the given area is 1.

## Intuition
Imagine a situation where you are superhero/demigod called Aquaman. You live in the sea and love it. But you are taught to swim in a way similar to a 2d matrix traversal. So you begin your swimming from the zeroth position of the given area and start your journey. As Aquaman, you love the sea and hence hate the land. So, whenever you encounter even a small patch of land, you destroy the whole island with your special ability called landSink and combine that area with the sea. Hence, when you complete your swimming and reach the end of the area, you meet your master and he questions you the number of islands you have destroyed. You look at him with a smile and say the number of times you have used your special landSink ability as it sinks the whole island at once.

The above tale completely explains the approach of the solution. You are given a matrix, and you have to calculate the total number of groups of 1 that are together. Hence we begin to iterate the 2d matrix, and when we meet an element which is equal to 1, we eliminate the whole group that is with it by converting all of them to 0's.

## Steps Followed
* Check if the given area/grid is greater than 0.
```swift
    guard grid.count > 0 else { return 0 }
    guard grid[0].count > 0 else { return 0 }
```
* Initialise a counter.
```swift 
var islandCounter = 0 
```
* Now traverse the given grid and when you encounter an element equal to 1,increment the islandCounter by 1 and call the landSink with the present indexes.
```swift
for i in 0..<grid.count{
        for j in 0..<grid[i].count{
            if grid[i][j] == "1"{
                islandCounter += 1
                landSink(&grid, i, j)
            }
        }
    }
```
* The function landSink works by taking in the indexes of the matrix and the matrix itself as its arguments. It checks if the indexes are valid and then checks if the present element is a land or not i.e. it checks whether the present element is equal to 1 or not. If true, it will sink it i.e. convert it into 0 and then check it's adjacent elements. If they too are 1, they will be converted to 0. This continues until the whole group of 1 is converted to 0.
```swift
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
```
* Finally return the islandCounter.
```swift
return islandCounter
```
## Worked Out Example
```
let area = [["1","1","0","0","0"],
            ["1","1","0","0","0"],
            ["0","0","1","0","0"],
            ["0","0","0","1","1"]]
```
The below gif represents on how the process works.

Note : Continue Moving refers to continue iterating until a land is reached.

![Island Gif](https://github.com/TheNova22/swift-algorithm-club/blob/numislands/Number%20Of%20Islands/Example.gif)

## Complete Code
```swift
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

```
*Written for Swift Algorithm Club by Jayant Sogikar*
