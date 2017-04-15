# 0-1 Knapsack 

The knapsack problem or rucksack problem is one of the most famous problems in [Dynamic Programming.](https://www.topcoder.com/community/data-science/data-science-tutorials/dynamic-programming-from-novice-to-advanced/) 

> Given a set of items, each with a weight and a value, determine the number of each item to include in a collection so that  the total weight is less than or equal to a given limit and the total value is as large as possible. - Wikipedia

<p align="center"><img src ="https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Knapsack.svg/250px-Knapsack.svg.png" /></p>

Given `KnapsackItem` items with corresponding weigths and values find the maximum total value in the knapsack by putting `KnapsackItem` items in a knapsack of capacity `capacityOfBag`. 

In other words, given array `knapsackItems` which represent values and weights associated with `KnapsackItem` items respectively. Also given an integer `capacityOfBag` which represents knapsack capacity, find out the maximum value subset of `knapsackItems` such that sum of the weights of this subset is smaller than or equal to `capacityOfBag`. You cannot break an item, either pick the complete item, or don’t pick it ([0-1 Knapsack Problem](http://www.geeksforgeeks.org/dynamic-programming-set-10-0-1-knapsack-problem/)).

## Solution

Whenever new item comes in you have to decide to pick this item or not and you have to find which gives you the maximum value. If you pick the item the maximum value will the value of the item plus whatever we get by subtracting this value from the total weight and excluding this item or the best you can do without including this item or both.

`capacityOfBag` is 7 and `knapsackItems`

weight | value
-------|------
1 | 1
3 | 4
4 | 5
5 | 7

Lets try solve this problem on two dimensional matrix `tableOfValues` where total number of columns is the same as `capacityOfBag`+1 and total number of rows is the same as the total `knapsackItems`.

(value) weight | 0 | 1 | 2 | 3 |4 | 5 | 6 | 7
---------------|---|---|---|---|--|---|---|--
(1) 1 | 0 |  |  |  |  |  |  | 
(4) 3 | 0 |  |  |  |  |  |  | 
(5) 4 | 0 |  |  |  |  |  |  | 
(7) 5 | 0 |  |  |  |  |  |  | 

The first column is **0** which means that if `capacityOfBag` is **0** no matter what items I have the maximum value will be **0**.

#### Lets start solving the problem

If the `capacityOfBag` is **1** and the weight of `KnapsackItem` is **1** the best we can do is **1**. Similarly, if the `capacityOfBag` is **2** and the weight of `KnapsackItem` is **1** the best we can do is **1**.

(value) weight | 0 | 1 | 2 | 3 |4 | 5 | 6 | 7
---------------|---|---|---|---|--|---|---|--
(1) 1 | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 1
(4) 3 | 0 |  |  |  |  |  |  | 
(5) 4 | 0 |  |  |  |  |  |  | 
(7) 5 | 0 |  |  |  |  |  |  | 

If the `capacityOfBag` is **1** and the weight of `KnapsackItem` is **3** which is greater than **1**, **3** can never be selected. So what we do is the best we can do without selecting **3** is **1**.

(value) weight | 0 | 1 :heavy_check_mark: | 2 | 3 |4 | 5 | 6 | 7
---------------|---|---|---|---|--|---|---|--
(1) 1 | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 1
(4) 3 | 0 | 1 |  |  |  |  |  | 
(5) 4 | 0 |  |  |  |  |  |  | 
(7) 5 | 0 |  |  |  |  |  |  | 

Again if the `capacityOfBag` is **2** and the weight of `KnapsackItem` is **3** which is greater than **2**, **3** can never be selected. So what we do is the best we can do without selecting **3** is **2**.

(value) weight | 0 | 1 | 2 :heavy_check_mark: | 3 |4 | 5 | 6 | 7
---------------|---|---|---|---|--|---|---|--
(1) 1 | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 1
(4) 3 | 0 | 1 | 1 |  |  |  |  | 
(5) 4 | 0 |  |  |  |  |  |  | 
(7) 5 | 0 |  |  |  |  |  |  |

If the `capacityOfBag` is **3** and the weight of `KnapsackItem` is **3** which is equal to **3**, we have to choices to select **3** or not select **3**. We have to check what is the best we can do by selecting this `KnapsackItem`.

If we select this item it gives us `value` **4** + whatever `weight` is remaining after we select this `KnapsackItem` is **3-3 = 0** by going up and moving three steps to left which is `tableOfValues[0][0]`. Or what is the best we can do without selecting this `KnapsackItem` which is 1.

```
max(4 + tableOfValues[1-1][3-3], tableOfValues[0][3]) = max(4 + 0, 1) = 4
```

(value) weight | 0 | 1 | 2 | 3 :heavy_check_mark: |4 | 5 | 6 | 7
---------------|---|---|---|---|--|---|---|--
(1) 1 | ***0*** | 1 | 1 |  ***1*** | 1 | 1 | 1 | 1
(4) 3 | 0 | 1 | 1 | 4 |  |  |  | 
(5) 4 | 0 |  |  |  |  |  |  | 
(7) 5 | 0 |  |  |  |  |  |  |

If the `capacityOfBag` is **4** and the weight of `KnapsackItem` is **3** which is less than **4**, we have to choices to select **3** or not select **3**. We have to check what is the best we can do by selecting this `KnapsackItem`.

If we select this item it gives us `value` **4** + whatever `weight` is remaining after we select this `KnapsackItem` is **4-3 = 1** by going up and moving three steps to left which is `tableOfValues[0][1]`. Or what is the best we can do without selecting this `KnapsackItem` which is 1.

```
max(4 + tableOfValues[1-1][4-3], tableOfValues[0][1]) = max(4 + 1, 1) = 5
```

(value) weight | 0 | 1 | 2 | 3  |4 :heavy_check_mark: | 5 | 6 | 7
---------------|---|---|---|---|--|---|---|--
(1) 1 | 0 | ***1*** | 1 | 1 | ***1*** | 1 | 1 | 1
(4) 3 | 0 | 1 | 1 | 4 | 5 |  |  | 
(5) 4 | 0 |  |  |  |  |  |  | 
(7) 5 | 0 |  |  |  |  |  |  |

If the `capacityOfBag` is **5** and the weight of `KnapsackItem` is **3** which is less than **5**, as before we have to choices to select **3** or not select **3**. We have to check what is the best we can do by selecting this `KnapsackItem`.

If we select this item it gives us `value` **4** + whatever `weight` is remaining after we select this `KnapsackItem` is **5-3 = 2** by going up and moving three steps to left which is `tableOfValues[0][2]`. Or what is the best we can do without selecting this `KnapsackItem` which is 1.

```
max(4 + tableOfValues[1-1][5-3], tableOfValues[0][2]) = max(4 + 1, 1) = 5
```

(value) weight | 0 | 1 | 2 | 3  |4  | 5 :heavy_check_mark: | 6 | 7
---------------|---|---|---|---|--|---|---|--
(1) 1 | 0 | 1 | ***1*** | 1 | ***1*** | 1 | 1 | 1
(4) 3 | 0 | 1 | 1 | 4 | 5 | 5 |  | 
(5) 4 | 0 |  |  |  |  |  |  | 
(7) 5 | 0 |  |  |  |  |  |  |

If the `capacityOfBag` is **6** or greater and we have two `KnapsackItem` **(1 and 3)** which weights are less than `capacityOfBag` the best we can do is to select both items.

(value) weight | 0 | 1 | 2 | 3  |4  | 5 | 6 :heavy_check_mark: | 7
---------------|---|---|---|---|--|---|---|--
(1) 1 | 0 | 1 | ***1*** | 1 | ***1*** | 1 | 1 | 1
(4) 3 | 0 | 1 | 1 | 4 | 5 | 5 | 5 | 5
(5) 4 | 0 |  |  |  |  |  |  | 
(7) 5 | 0 |  |  |  |  |  |  |

Using similar algorithmic approach we fill `tableOfValues`.

(value) weight | 0 | 1 | 2 | 3  |4  | 5 | 6 | 7
---------------|---|---|---|---|--|---|---|--
(1) 1 | 0 | 1 | 1| 1 | 1| 1 | 1 | 1
(4) 3 | 0 | 1 | 1 | 4 | 5 | 5 | 5 | 5
(5) 4 | 0 | 1 | 1 | 4 | 5 | 6 | 6 | 9
(7) 5 | 0 | 1 | 1 | 4 |  5| 7 | 8 | 9 :small_blue_diamond:

The answer for the problem is the value at `tableOfValues[3][7]` which is **9**.

Testing


