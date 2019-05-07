/*:
 ## Dijkstra's algorithm visualization
 This playground is about the [Dijkstra's algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm).
 Plyground works in 2 modes:
 * Auto visualization
 * Interactive visualization

 */
import UIKit
import PlaygroundSupport

/*:
 First of all, let's set up colors for our window and graph. The visited color will be applied to visited vertices. The checking color will be applied to an edge and an edge neighbor every time the algorithm is checking some vertex neighbors. And default colors are just initial colors for elements.
 */
GraphColors.sharedInstance.visitedColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
GraphColors.sharedInstance.checkingColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
GraphColors.sharedInstance.defaultEdgeColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
GraphColors.sharedInstance.defaultVertexColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)

GraphColors.sharedInstance.mainWindowBackgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
GraphColors.sharedInstance.topViewBackgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
GraphColors.sharedInstance.buttonsBackgroundColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
GraphColors.sharedInstance.graphBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
/*:
 Now, we need to create some graph. You can create graph with any vertices amount but I aware you from setting up too many, otherwise it will be hard to place all of them nicely on the screen. Also, you can change the animations' duration: slow down or speed up.
 */
let graph = Graph(verticesCount: 6)
graph.interactiveNeighborCheckAnimationDuration = 1.2
graph.visualizationNeighborCheckAnimationDuration = 1.2
/*:
 Now, let's configure the graph's visual representation by passing the virtual graph to our window. For better perception open live view in full screen.
 */
let screenBounds = UIScreen.main.bounds
let frame = CGRect(x: 0, y: 0, width: screenBounds.width * 0.8, height: screenBounds.height * 0.8)
let window = Window(frame: frame)
window.configure(graph: graph)
PlaygroundPage.current.liveView = window
/*:
 **Great!**

 Now we have graph on the screen. It is beautiful, isn't it? ;) Before the visualization starts, I recommend you to move vertices around the screen using you finger to be sure that all vertices and edges are properly visible.
 
 And a final step! Before you will see the visualization **(by pressing "Visualization" button),** please, read explanation of how the Dijkstra's algorithm works.

 Algorithm's flow:
 First of all, this program randomly decides which vertex will be the start one, then the program assigns a zero value to the start vertex path length from the start.

 Then the algorithm repeats following cycle until all vertices are marked as visited.
 Cycle:
 1) From the non-visited vertices the algorithm picks a vertex with the shortest path length from the start (if there are more than one vertex with the same shortest path value, then algorithm picks any of them)
 2) The algorithm marks picked vertex as visited.
 3) The algorithm check all of its neighbors. If the current vertex path length from the start plus an edge weight to a neighbor less than the neighbor current path length from the start, than it assigns new path length from the start to the neihgbor.
 When all vertices are marked as visited, the algorithm's job is done. Now, you can see the shortest path from the start for every vertex by pressing the one you are interested in.
 
 Now, try yourself at the Dijkstra's algorithm. Press **"Interactive" button.** The program will mark the start vertex as visited and calculate new paths for its neighbors. You have to pick next vertex for the algorithm to check. If you are wrong, you will see a message on the screen.
 
 Good luck and have fun! ;)
 */
