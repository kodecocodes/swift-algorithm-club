# Single-Source Shortest Paths

The Single-Source shortest path problem finds the shortest paths from a given source vertex to all other vertices in a directed weighted graph. Many variations exist on the problem, specifying whether or not edges may have negative values, whether cycles exist, or whether a path between a specific pair of vertices.

## Bellman-Ford

The Bellman-Ford shortest paths algorithm finds the shortest paths to all vertices from a given source vertex `s` in a directed graph that may contain negative edge weights. It iterates over all edges for each other vertex in the graph, applying a relaxation to the current state of known shortest path weights. The intuition here is that a path will not contain more vertices than are present in the graph, so performing a pass over all edges `|V|-1` number of times is sufficient to compare all possible paths. 

At each step, a value is stored for each vertex `v`, which is the weight of the current known shortest path `s`~>`v`. This value remains 0 for the source vertex itself, and all others are initially `∞`. Then, they are "relaxed" by applying the following test to each edge `e = (u, v)` (where `u` is a source vertex and `v` is a destination vertex for the directed edge):

	if weights[v] > weights[u] + e.weight {
		weights[v] = weights[u] + e.weight
	}

Bellman-Ford in essence only computes the lengths of the shortest paths, but can optionally maintain a structure that memoizes the predecessor of each vertex on its shortest path from the source vertex.  Then the paths themselves can be reconstructed by recursing through this structure from a destination vertex to the source vertex. This is maintained by simply adding the statement

	predecessors[v] = u
	
inside of the `if` statement's body above.

### Example

For the following weighted directed graph:

<img src="img/example_graph.png" width="200px" />

let's compute the shortest paths from vertex `s`. First, we prepare our `weights` and `predecessors` structures thusly:

| weights | predecessors |
| ------------- |:-------------:|
| `weights[s] = 0` | `predecessors[s] = 1` |
| `weights[t] = ∞` | `predecessors[t] = ø` |
| `weights[x] = ∞` | `predecessors[x] = ø` |
| `weights[y] = ∞` | `predecessors[y] = ø` |
| `weights[z] = ∞` | `predecessors[z] = ø` |

Here are their states after each relaxation iteration (each iteration is a pass over all edges, and there are 4 iterations total for this graph):

###### Iteration 1:

| weights | predecessors |
| ------------- |:-------------:|
| `weights[s] = 0` | `predecessors[s] = s` |
| `weights[t] = 6` | `predecessors[t] = s` |
| `weights[x] = 4` | `predecessors[x] = y` |
| `weights[y] = 7` | `predecessors[y] = s` |
| `weights[z] = 2` | `predecessors[z] = t` |

###### Iteration 2:

| weights | predecessors |
| ------------- |:-------------:|
| `weights[s] = 0` | `predecessors[s] = s` |
| `weights[t] = 2` | `predecessors[t] = x` |
| `weights[x] = 4` | `predecessors[x] = y` |
| `weights[y] = 7` | `predecessors[y] = s` |
| `weights[z] = 2` | `predecessors[z] = t` |

###### Iteration 3:

| weights | predecessors |
| ------------- |:-------------:|
| `weights[s] = 0` | `predecessors[s] = s` |
| `weights[t] = 2` | `predecessors[t] = x` |
| `weights[x] = 4` | `predecessors[x] = y` |
| `weights[y] = 7` | `predecessors[y] = s` |
| `weights[z] = -2` | `predecessors[z] = t` |

###### Iteration 4:

| weights | predecessors |
| ------------- |:-------------:|
| `weights[s] = 0` | `predecessors[s] = s` |
| `weights[t] = 2` | `predecessors[t] = x` |
| `weights[x] = 4` | `predecessors[x] = y` |
| `weights[y] = 7` | `predecessors[y] = s` |
| `weights[z] = -2` | `predecessors[z] = t` |

#### Negative weight cycles

An additional useful property of the solution structure is that it can answer whether or not a negative weight cycle exists in the graph and is reachable from the source vertex. A negative weight cycle is a cycle whose sum of edge weights is negative. This means that shortest paths are not well defined in the graph from the specified source, because you can decrease the weight of a path by reentering the cycle, pushing the path's weight towards `-∞`. After fully relaxing the paths, simply running a check over each edge `e = (u, v)` to see if the weight of the shortest path to `v` is greater than the path to `u`, plus the edge weight itself, signals that the edge has a negative weight and would decrease the shortest path's weight further. Since we know we've already performed the relaxations enough times according to the intuition stated above, we can safely assume this further decrease of weight will continue infinitely.

##### Example

For this example, we try to compute the shortest paths from `a`:

<img src="img/negative_cycle_example.png" width="200px" />

The cycle `a`->`t`->`s`->`a` has a total edge weight of -9, therefore shortest paths for `a`~>`t` and `a`~>`s` are not well-defined. `a`~>`b` is also not well-defined because `b`->`t`->`s` is also a negative weight cycle.

This is confirmed after running the relaxation loop, and checking all the edges as mentioned above. For this graph, we would have after relaxation:

| weights |
| ------------- |
| `weights[a] = -5` |
| `weights[b] = -5` |
| `weights[s] = -18` |
| `weights[t] = -3` |

One of the edge checks we would perform afterwards would be the following:

	e = (s, a)
	e.weight = 4
	weight[a] > weight[s] + e.weight => -5 > -18 + 4 => -5 > -14 => true
	
Because this check is true, we know the graph has a negative weight cycle reachable from `a`.

#### Complexity

The relaxation step requires constant time (`O(1)`) as it simply performs comparisons. That step is performed once per edge (`Θ(|E|)`), and the edges are iterated over `|V|-1` times. This would mean a total complexity of `Θ(|V||E|)`, but there is an optimization we can make: if the outer loop executes and no changes are made to the recorded weights, we can safely terminate the relaxation phase, which means it may execute in `O(|V|)` steps instead of `Θ(|V|)` steps (that is, the best case for any size graph is actually a constant number of iterations; the worst case is still iterating `|V|-1` times).

The check for negative weight cycles at the end is `O(|E|)` if we return once we find a hit. To find all negative weight cycles reachable from the source vertex, we'd have to iterate `Θ(|E|)` times (we currently do not attempt to report the cycles, we simply return a `nil` result if such a cycle is present).

The total running time of Bellman-Ford is therefore `O(|V||E|)`.

## TODO

- Dijkstra's algorithm for computing SSSP on a directed non-negative weighted graph

# References

- Chapter 24 of Introduction to Algorithms, Third Edition by Cormen, Leiserson, Rivest and Stein [https://mitpress.mit.edu/books/introduction-algorithms](https://mitpress.mit.edu/books/introduction-algorithms)
- Wikipedia: [Bellman–Ford algorithm](https://en.wikipedia.org/wiki/Bellman–Ford_algorithm)

*Written for Swift Algorithm Club by [Andrew McKnight](https://github.com/armcknight)*