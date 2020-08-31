# Flood Fill Algorithm 

Flood Fill Algorithm can be used for just finding(and counting the number of) connected components and usaully performed on implicit graphs (usually 2D grids). The flood-fill algorithm takes three parameters: a start node, a target color, and a replacement color. The algorithm looks for all nodes in the array that are connected to the start node by a path of the target color and changes them to the replacement color. 


**Famous implementation of flood fill algorithm is:** 
- Solving a Maze:  Given a matrix with some starting point, and some destination with some obstacles in between, this algorithm helps to find out the path from source to destination


## Example 
if you have a grid that containts characters 'L' and W', 'L' denotes a land cell and 'W' denotes a wet cell.

for example the grid will like this:

```
LLLLLLLLL
LLWWLLWLL
LWWLLLLLL
LWWWLWWLL
LLLWWWLLL
LLLLLLLLL
LLLWWLLWL
LLWLWLLLL
LLLLLLLLL
```

// read the grid as a global 2D array + read (row, col) query coordinates

The example below shows an execution of floodfill from row 2, column 1 (0-based indexing), replacing ‘W’ to ‘.’ 

```

LLLLLLLLL                  LLLLLLLLL
LLWWLLWLL                  LL..LLWLL
LWWLLLLLL      (R2,C1)     L..LLLLLL
LWWWLWWLL    ==========>   L...L..LL
LLLWWWLLL                  LLL...LLL
LLLLLLLLL                  LLLLLLLLL
LLLWWLLWL                  LLLWWLLWL
LLWLWLLLL                  LLWLWLLLL
LLLLLLLLL                  LLLLLLLLL

```


## The Code 

```swift

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
    
    var ans = 1         // adds 1 to ans because vertex (r, c) has c1 as its W
    grid[r][c] = c2     // now recolors vertex (r, c) to c2 to avoid cycling!
    for n in 0...7 {
       ans += floodFill(r: r + dr[n], c: c + dc[n], c1: c1, c2: c2, R: R, C: C)
    }
    return ans
}

```

