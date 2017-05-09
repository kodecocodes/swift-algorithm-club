# 单源最短路径

单源最短路径问题就是找到带权有向图中一个给定源顶点到其他所有顶点的最短路径。这个问题有许多变化，边是否可以有负值、是否存在环，特定顶点对之间是否存在路径。

## Bellman-Ford

Bellman-Ford 最短路径算法是找到包含负值边权重的有向图中的给定源顶点 s 到所有顶点的最短路径。它会遍历图中每个定点的所有边，然后对当前已知最短路径权重施加一个松弛方法。最明显的一点就是路径不会包含比当前图中的顶点数还多的店，所以执行一个所有边数 `|V|-1` 次数的传递就足够来对比所有的路径了。

在每一步中，每个顶点 `v` 都存储一个值，这个值表示的是 `s`~>`v` 当前已知的最短路径的权重。对于源顶点自己来说这个值就是 0，对于其他顶点来说开始就是 `∞`。然后通过对每一条边 `e = (u, v)` 都执行下面的测试来让他们 “松弛”（`u` 是源顶点，`v` 是直接变的目标顶点）：

	if weights[v] > weights[u] + e.weight {
		weights[v] = weights[u] + e.weight
	}

Bellman-Ford 基本上只计算最短路径的长度，但是也可以选择性的维护一个结构用来存储从源顶点到每个顶点的最短路径上的祖先顶点。然后路径本身可以通过检索从目标顶点到源顶点的结构来重新构建。这是通过简单地添加下面的语句来维护的 

	predecessors[v] = u
	
在上面的 if 语句里面。

### 示例

洗浴下面的带权有向图：

<img src="img/example_graph.png" width="200px" />

我们来计算顶点 `s` 的最短路径。首先，准备 `weights` 和 `predecessors` 结构：

| weights | predecessors |
| ------------- |:-------------:|
| `weights[s] = 0` | `predecessors[s] = 1` |
| `weights[t] = ∞` | `predecessors[t] = ø` |
| `weights[x] = ∞` | `predecessors[x] = ø` |
| `weights[y] = ∞` | `predecessors[y] = ø` |
| `weights[z] = ∞` | `predecessors[z] = ø` |

下面是每次松弛迭代之后的状态（每次迭代都要经过所有的边，对于这个图来说总共有四次迭代）：

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

#### 负权重环

这个解的结构的另外一个有用的属性是它可以回到在图中是否存在负权重环以及是否能从源顶点到达。负权重环是是边的权重为负的环。这就意味着图中指定源顶点的最短路径没有定义，因为可以通过重新进入环来降低路径的权重，最后将路径的权重变为 `-∞`。在完全松弛路径之后，简单地对每条边 `e = (u, v)` 执行一个检查，加上边的权重来看看到 `v` 的最短路径的权重是否比 到 `u` 的要大。有负权重的边会进一步减少路径的权重。因为根据上面列出的知识可以知道我们已经执行了足够次数的松弛，我们可以安全地认为进一步使权重降低会无限的继续下去。

##### 示例

对于这个例子，我们试着计算从 `a` 开始的最短路径：

<img src="img/negative_cycle_example.png" width="200px" />

环 `a`->`t`->`s`->`a` 的总的边的权重是 -9，因此 `a`~>`t` 和 `a`~>`s` 的最短路径是没有定义的。`a`~>`b` 的也是没有定义的，因为 `b`->`t`->`s` 也是一个负权重环。

这个在执行完松弛循环之后并且做上面提到的所有边的检查。对于这个图来说，我们会做下面的松弛：

| weights |
| ------------- |
| `weights[a] = -5` |
| `weights[b] = -5` |
| `weights[s] = -18` |
| `weights[t] = -3` |

后面我们要做的对于边的检查是下面这样的：

	e = (s, a)
	e.weight = 4
	weight[a] > weight[s] + e.weight => -5 > -18 + 4 => -5 > -14 => true
	
因为这个检查为真，我们就知道这个图有一个从 `a` 可以到达的负权重环。

#### 复杂度

松弛步骤值需要常量时间 (`O(1)`)，因为它做简单的比较。每条边都会执行一步 (`Θ(|E|)`)，所有的边会执行 `|V|-1` 次。这就意味着总的时间复杂度是 `Θ(|V||E|)`，但是我们可以做一个优化：如果做了外层循环，但是记录的权重没有任何变化，我们就可以安全地结束松弛，这就意味着可能执行 `O(|V|)`步 而不是 `Θ(|V|)` 步（也就是说，对于任何图来说最好的情况实际上只花了常量次数的迭代，最差的情况依然是迭代 `|V|-1` 次）。

如果我们在找到之后就返回的话，那么最后的负权重环的检查就是 `O(|E|)`。为了找到从源顶点可到达的所有负权重环，我们必须要迭代 `Θ(|E|)` 次（目前我们不打算报告环，我们只是在环存在时简单的返回 `nil`）。

Bellman-Ford 的总运行时间时间最后是 `O(|V||E|)`。

## TODO

- Dijkstra 算法是用于计算有向非负权重图的 SSSP。

# 参考

- 算法导论第 24 章, 第三版 Cormen, Leiserson, Rivest and Stein [https://mitpress.mit.edu/books/introduction-algorithms](https://mitpress.mit.edu/books/introduction-algorithms)
- 维基百科： [Bellman–Ford algorithm](https://en.wikipedia.org/wiki/Bellman–Ford_algorithm)

*作者：[Andrew McKnight](https://github.com/armcknight) 翻译：Daisy*

