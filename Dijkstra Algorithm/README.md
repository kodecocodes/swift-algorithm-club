# Dijkstra-algorithm

This algorithm was invented in 1956 by Edsger W. Dijkstra. 

This algorithm can be used, when you have one source vertex and want to find the shortest paths to all other vertices in the graph.

The best example is road network. If you wnat to find the shortest path from your house to your job, then it is time for the Dijkstra's algorithm.

I have a gif example, which will show you how algorithm works. If this is not enough, then you can play with my **VisualizedDijkstra.playground**.
So let's image, that your house is "A" vertex and your job is "B" vertex. And you are lucky, you have graph with all possible routes.
When the algorithm starts to work initial graph looks like this:
[image1.png]

The table below will represent graph state

|                           |  A  |  B  |  C  |  D  |  E  |
| ------------------------- | --- | --- | --- | --- | --- |
| Visited                   |  F  |  F  |  F  |  F  |  F  |
| Path Length From Start    | inf | inf | inf | inf | inf |
| Path Vertices From Start  | [ ] | [ ] | [ ] | [ ] | [ ] |

Graph's array contains 5 vertices [A, B, C, D, E].
Let's assume, that edge weight it is path length in kilometers between vertices.
A vertex has neighbors: B(path from A: 5.0), C(path from A: 0.0), D(path from A: 0.0)
And because algorithm has done nothing, then all vertices' path length from source vertex values are infinity (think about infinity as "I don't know, how long will it takes to get this vertex from source one")
Finally we have to set source vertex path length from source vertex to 0.

Great, now our graph is initialized and we can pass it to the Dijkstra's algorithm.

But before we will go through all process side by side let me explain how algorithm works.
The algorithm repeats following cycle until all vertices are marked as visited.
Cycle:
1. From the non-visited vertices the algorithm picks a vertex with the shortest path length from the start (if there are more than one vertex with the same shortest path value, then algorithm picks any of them)
2. The algorithm marks picked vertex as visited.
3. The algorithm check all of its neighbors. If the current vertex path length from the start plus an edge weight to a neighbor less than the neighbor current path length from the start, than it assigns new path length from the start to the neihgbor.
When all vertices are marked as visited, the algorithm's job is done. Now, you can see the shortest path from the start for every vertex by pressing the one you are interested in.

Okay, let's start!
From now we will keep array which contains non visited vertices. Here they are:
var nonVisitedVertices = [A, B, C, D, E]
Let's follow the algorithm and pick the first vertex, which neighbors we want to check.
Imagine that we have function, that returns vertex with smallest path length from start.
var checkingVertex = nonVisitedVertices.smallestPathLengthFromStartVertex()
Then we set this vertex as visited 

|                           |  A  |  B  |  C  |  D  |  E  |
| ------------------------- | --- | --- | --- | --- | --- |
| Visited                   |  T  |  F  |  F  |  F  |  F  |
| Path Length From Start    |  0  | inf | inf | inf | inf |
| Path Vertices From Start  | [A] | [ ] | [ ] | [ ] | [ ] |

checkingVertex.visited = true
[image2.jpg]
Then we check all of its neighbors. 
If neighbor's path length from start is bigger than checking vertex path length from start + edge weigth, then we set neighbor's path length from start new value and append to its pathVerticesFromStart array new vertex: checkingVertex. Repeat this action for every vertex.
[image3.jpg]

|                           |     A      |     B      |     C      |     D      |     E      |
| ------------------------- | ---------- | ---------- | ---------- | ---------- | ---------- |
| Visited                   |     T      |     F      |     F      |     F      |     F      |
| Path Length From Start    |     0      |     3      |    inf     |     1      |    inf     |
| Path Vertices From Start  |    [A]     |   [A, B]   |    [ ]     |   [A, D]   |    [ ]     |

[image4.jpg]

|                           |     A      |     B      |     C      |     D      |     E      |
| ------------------------- | ---------- | ---------- | ---------- | ---------- | ---------- |
| Visited                   |     T      |     F      |     F      |     T      |     F      |
| Path Length From Start    |     0      |     3      |    inf     |     1      |     2      |
| Path Vertices From Start  |    [A]     |   [A, B]   |    [ ]     |   [A, D]   | [A, D, E]  |

[image5.jpg]

|                           |     A      |     B      |     C      |     D      |     E      |
| ------------------------- | ---------- | ---------- | ---------- | ---------- | ---------- |
| Visited                   |     T      |     F      |     F      |     T      |     T      |
| Path Length From Start    |     0      |     3      |     11     |     1      |     2      |
| Path Vertices From Start  |    [A]     |   [A, B]   |[A, D, E, C]|   [A, D]   | [A, D, E ] |

[image6.jpg]

|                           |     A      |     B      |     C      |     D      |     E      |
| ------------------------- | ---------- | ---------- | ---------- | ---------- | ---------- |
| Visited                   |     T      |     T      |     F      |     T      |     T      |
| Path Length From Start    |     0      |     3      |     8      |     1      |     2      |
| Path Vertices From Start  |    [A]     |   [A, B]   |   [A, B, C]|   [A, D]   | [A, D, E ] |

[image7.jpg]

|                           |     A      |     B      |     C      |     D      |     E      |
| ------------------------- | ---------- | ---------- | ---------- | ---------- | ---------- |
| Visited                   |     T      |     T      |     T      |     T      |     T      |
| Path Length From Start    |     0      |     3      |     8      |     1      |     2      |
| Path Vertices From Start  |    [A]     |   [A, B]   |   [A, B, C]|   [A, D]   | [A, D, E ] |

This repository contains to playgrounds:
* To understand how does this algorithm works, I have created **VisualizedDijkstra.playground.** It works in auto and interactive modes. Moreover there are play/pause/stop buttons.
* If you need only realization of the algorithm without visualization then run **Dijkstra.playground.** It contains necessary classes and couple functions to create random graph for algorithm testing.

## Dijkstra's algorithm explanation



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
This algorithm is popular in routing. For example, biggest Russian IT company Yandex uses it in [Яндекс.Карты](https://yandex.ru/company/technologies/routes/)

## Demo video
Click the link: [YouTube](https://youtu.be/PPESI7et0cQ)

## Credits
WWDC 2017 Scholarship Project  
Created by [Taras Nikulin](https://github.com/crabman448)
