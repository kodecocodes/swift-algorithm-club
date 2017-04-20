# Dijkstra's algorithm

This algorithm was invented in 1956 by Edsger W. Dijkstra. 

This algorithm can be used, when you have one source vertex and want to find the shortest paths to all other vertices in the graph.

The best example is road network. If you wnat to find the shortest path from your house to your job, then it is time for the Dijkstra's algorithm.

I have created **VisualizedDijkstra.playground** to help you to understand, how this algorithm works. Besides, I have described below step by step how does it works.

So let's imagine, that your house is "A" vertex and your job is "B" vertex. And you are lucky, you have graph with all possible routes.

> Initialization

When the algorithm starts to work initial graph looks like this:

<img src="Images/image1.png" height="250" />

The table below represents graph state:

|                           |  A  |  B  |  C  |  D  |  E  |
|:------------------------- |:---:|:---:|:---:|:---:|:---:|
| Visited                   |  F  |  F  |  F  |  F  |  F  |
| Path Length From Start    | inf | inf | inf | inf | inf |
| Path Vertices From Start  | [ ] | [ ] | [ ] | [ ] | [ ] |

_inf is equal infinity, which basically means, that algorithm doesn't know how far away is this vertex from start one._
_F states for False_
_T states for True_

To initialize out graph we have to set source vertex path length from source vertex to 0.

|                           |  A  |  B  |  C  |  D  |  E  |
|:------------------------- |:---:|:---:|:---:|:---:|:---:|
| Visited                   |  F  |  F  |  F  |  F  |  F  |
| Path Length From Start    |  0  | inf | inf | inf | inf |
| Path Vertices From Start  | [ ] | [ ] | [ ] | [ ] | [ ] |

Great, now our graph is initialized and we can pass it to the Dijkstra's algorithm.

But before we will go through all process side by side let me explain how algorithm works.
The algorithm repeats following cycle until all vertices are marked as visited.
Cycle:
1. From the non-visited vertices the algorithm picks a vertex with the shortest path length from the start (if there are more than one vertex with the same shortest path value, then algorithm picks any of them)
2. The algorithm marks picked vertex as visited.
3. The algorithm check all of its neighbors. If the current vertex path length from the start plus an edge weight to a neighbor less than the neighbor current path length from the start, than it assigns new path length from the start to the neihgbor.
When all vertices are marked as visited, the algorithm's job is done. Now, you can see the shortest path from the start for every vertex by pressing the one you are interested in.

Okay, let's start!
Let's follow the algorithm's cycle and pick the first vertex, which neighbors we want to check.
All our vertices are not visited, but there is only one have the smallest path length from start - A. This vertex is th first one, which neighbors we will check.
First of all, set this vertex as visited 

A.visited = true

<img src="Images/image2.png" height="250" />

After this step graph has this state:

|                           |  A  |  B  |  C  |  D  |  E  |
|:------------------------- |:---:|:---:|:---:|:---:|:---:|
| Visited                   |  T  |  F  |  F  |  F  |  F  |
| Path Length From Start    |  0  | inf | inf | inf | inf |
| Path Vertices From Start  | [A] | [ ] | [ ] | [ ] | [ ] |

## Step 1

Then we check all of its neighbors. 
If checking vertex path length from start + edge weigth is smaller than neighbor's path length from start, then we set neighbor's path length from start new value and append to its pathVerticesFromStart array new vertex: checkingVertex. Repeat this action for every vertex.

for clarity:
```swift
if (A.pathLengthFromStart + AB.weight) < B.pathLengthFromStart {
    B.pathLengthFromStart = A.pathLengthFromStart + AB.weight
    B.pathVerticesFromStart = A.pathVerticesFromStart
    B.pathVerticesFromStart.append(B)
}
```
And now our graph looks like this one:

<img src="Images/image3.png" height="250" />

And its state is here:

|                           |     A      |     B      |     C      |     D      |     E      |
|:------------------------- |:----------:|:----------:|:----------:|:----------:|:----------:|
| Visited                   |     T      |     F      |     F      |     F      |     F      |
| Path Length From Start    |     0      |     3      |    inf     |     1      |    inf     |
| Path Vertices From Start  |    [A]     |   [A, B]   |    [ ]     |   [A, D]   |    [ ]     |

## Step 2

From now we repeat all actions again and fill our table with new info! 

<img src="Images/image4.png" height="250" />

|                           |     A      |     B      |     C      |     D      |     E      |
|:------------------------- |:----------:|:----------:|:----------:|:----------:|:----------:|
| Visited                   |     T      |     F      |     F      |     T      |     F      |
| Path Length From Start    |     0      |     3      |    inf     |     1      |     2      |
| Path Vertices From Start  |    [A]     |   [A, B]   |    [ ]     |   [A, D]   | [A, D, E]  |

## Step 3

<img src="Images/image5.png" height="250" />

|                           |     A      |     B      |     C      |     D      |     E      |
|:------------------------- |:----------:|:----------:|:----------:|:----------:|:----------:|
| Visited                   |     T      |     F      |     F      |     T      |     T      |
| Path Length From Start    |     0      |     3      |     11     |     1      |     2      |
| Path Vertices From Start  |    [A]     |   [A, B]   |[A, D, E, C]|   [A, D]   | [A, D, E ] |

## Step 4

<img src="Images/image6.png" height="250" />

|                           |     A      |     B      |     C      |     D      |     E      |
|:------------------------- |:----------:|:----------:|:----------:|:----------:|:----------:|
| Visited                   |     T      |     T      |     F      |     T      |     T      |
| Path Length From Start    |     0      |     3      |     8      |     1      |     2      |
| Path Vertices From Start  |    [A]     |   [A, B]   |   [A, B, C]|   [A, D]   | [A, D, E ] |

## Step 5

<img src="Images/image7.png" height="250" />

|                           |     A      |     B      |     C      |     D      |     E      |
|:------------------------- |:----------:|:----------:|:----------:|:----------:|:----------:|
| Visited                   |     T      |     T      |     T      |     T      |     T      |
| Path Length From Start    |     0      |     3      |     8      |     1      |     2      |
| Path Vertices From Start  |    [A]     |   [A, B]   |   [A, B, C]|   [A, D]   | [A, D, E ] |

## About

This repository contains to playgrounds:
* To understand how does this algorithm works, I have created **VisualizedDijkstra.playground.** It works in auto and interactive modes. Moreover there are play/pause/stop buttons.
* If you need only realization of the algorithm without visualization then run **Dijkstra.playground.** It contains necessary classes and couple functions to create random graph for algorithm testing.





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
