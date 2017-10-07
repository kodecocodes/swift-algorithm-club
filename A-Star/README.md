# A*

A* (pronounced "ay star") is a heuristic best-first search algorithm. A* minimizes node expansions, therefore minimizing the search time, by using a heuristic function. The heuristic function gives an estimate of the distance between two vertices. For instance if you are searching for a path between two points in a city, you can estimate the actual street distance with the straight-line distance.

A* works by expanding the most promising nodes first, according to the heuristic function. In the city example it would choose streets which go in the general direction of the target first and, only if those are dead ends, backtrack and try other streets. This speeds up search in most sitations.

A* is optimal (it always find the shortest path) if the heuristic function is admissible. A heuristic function is admissible if it never overestimates the cost of reaching the goal. In the extreme case of the heuristic function always retuning `0` A* acts exactly the same as [Dijkstra's Algorithm](../Dijkstra). The closer the heuristic function is the the actual distance the faster the search.
