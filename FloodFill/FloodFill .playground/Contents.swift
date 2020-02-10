/*
 Flood Fill Algorithm can be used for just finding(and counting the number of) connected components and usaully performed on implicit graphs (usually 2D grids)
*/

/*
 Example:
 if you have a grid that containts characters 'L' and W', 'L' denotes a land cell and 'W' denotes a wet cell.
 
 for example the grid will like this:
 LLLLLLLLL
 LLWWLLWLL
 LWWLLLLLL
 LWWWLWWLL
 LLLWWWLLL
 LLLLLLLLL
 LLLWWLLWL
 LLWLWLLLL
 LLLLLLLLL
 
 // read the grid as a global 2D array + read (row, col) query coordinates
 
 print(floodfill(row, col, ‘W’, ‘.’,R,C))
 The example below shows an execution of floodfill from row 2, column 1 (0-based indexing), replacing ‘W’ to ‘.’.
 
 LLLLLLLLL                  LLLLLLLLL
 LLWWLLWLL                  LL..LLWLL
 LWWLLLLLL      (R2,C1)     L..LLLLLL
 LWWWLWWLL    ==========>   L...L..LL
 LLLWWWLLL                  LLL...LLL
 LLLLLLLLL                  LLLLLLLLL
 LLLWWLLWL                  LLLWWLLWL
 LLWLWLLLL                  LLWLWLLLL
 LLLLLLLLL                  LLLLLLLLL

 
 */

var dr = [0,0,1,-1,1,-1,-1,1]
var dc = [1,-1,0,0,1,-1,1,-1]

var grid = [[Character]]()

func floodFill(r:Int,c:Int,c1:Character,c2:Character,R:Int,C:Int)-> Int{
    // C  is the number of columns
    // R is the number of rows
    if r<0 || c<0 || r >= R || c >= C {    // outside the grid
        return 0
    }
    if grid[r][c] != c1 {       // does not have c1
        return 0
    }
    
    var ans = 1
    grid[r][c] = c2
    for n in 0...7 {
       ans += floodFill(r: r + dr[n], c: c + dc[n], c1: c1, c2: c2, R: R, C: C)
    }
    return ans
}
