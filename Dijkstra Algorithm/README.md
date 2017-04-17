# Dijkstra-algorithm

## About this repository
This repository contains to playgrounds:
* To understand how does this algorithm works, I have created **VisualizedDijkstra.playground.** It works in auto and interactive modes. Moreover there are play/pause/stop buttons.
* If you need only realization of the algorithm without visualization then run **Dijkstra.playground.** It contains necessary classes and couple functions to create random graph for algorithm testing.

## Demo video
Click the link: [YouTube](https://youtu.be/PPESI7et0cQ)

## Screenshots
<img src="Images/screenshot1.jpg" height="400" />

## Dijkstra's algorithm explanation

<img src="Images/Dijkstra_Animation.gif" height="250" />

[Wikipedia](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm)'s explanation:
Let the node at which we are starting be called the initial node. Let the distance of node Y be the distance from the initial node to Y. Dijkstra's algorithm will assign some initial distance values and will try to improve them step by step.

1. Assign to every node a tentative distance value: set it to zero for our initial node and to infinity for all other nodes.
2. Set the initial node as current. Mark all other nodes unvisited. Create a set of all the unvisited nodes called the unvisited set.
3. For the current node, consider all of its unvisited neighbors and calculate their tentative distances. Compare the newly calculated tentative distance to the current assigned value and assign the smaller one. For example, if the current node A is marked with a distance of 6, and the edge connecting it with a neighbor B has length 2, then the distance to B (through A) will be 6 + 2 = 8. If B was previously marked with a distance greater than 8 then change it to 8. Otherwise, keep the current value.
4. When we are done considering all of the neighbors of the current node, mark the current node as visited and remove it from the unvisited set. A visited node will never be checked again.
5. If the destination node has been marked visited (when planning a route between two specific nodes) or if the smallest tentative distance among the nodes in the unvisited set is infinity (when planning a complete traversal; occurs when there is no connection between the initial node and remaining unvisited nodes), then stop. The algorithm has finished.
6. Otherwise, select the unvisited node that is marked with the smallest tentative distance, set it as the new "current node", and go back to step 3.

Explanation, that can be found in the **VisualizedDijkstra.playground**
Algorithm's flow:
First of all, this program randomly decides which vertex will be the start one, then the program assigns a zero value to the start vertex path length from the start.

Then the algorithm repeats following cycle until all vertices are marked as visited.
Cycle:
1. From the non-visited vertices the algorithm picks a vertex with the shortest path length from the start (if there are more than one vertex with the same shortest path value, then algorithm picks any of them)
2. The algorithm marks picked vertex as visited.
3. The algorithm check all of its neighbors. If the current vertex path length from the start plus an edge weight to a neighbor less than the neighbor current path length from the start, than it assigns new path length from the start to the neihgbor.
When all vertices are marked as visited, the algorithm's job is done. Now, you can see the shortest path from the start for every vertex by pressing the one you are interested in.

## Usage



## Credits
WWDC 2017 Scholarship Project  
Created by [Taras Nikulin](https://github.com/crabman448)
