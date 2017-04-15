# 0-1 Knapsack 

The knapsack problem or rucksack problem is one of the most famous problems in [Dynamic Programming.](https://www.topcoder.com/community/data-science/data-science-tutorials/dynamic-programming-from-novice-to-advanced/) 

> Given a set of items, each with a weight and a value, determine the number of each item to include in a collection so that  the total weight is less than or equal to a given limit and the total value is as large as possible. - Wikipedia

<p align="center"><img src ="https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Knapsack.svg/250px-Knapsack.svg.png" /></p>

Given `KnapsackItem` items with corresponding weigths and values find the maximum total value in the knapsack by putting `KnapsackItem` items in a knapsack of capacity `capacityOfBag`. 

In other words, given array `knapsackItems` which represent values and weights associated with `KnapsackItem` items respectively. Also given an integer `capacityOfBag` which represents knapsack capacity, find out the maximum value subset of `knapsackItems` such that sum of the weights of this subset is smaller than or equal to `capacityOfBag`. You cannot break an item, either pick the complete item, or don’t pick it ([0-1 Knapsack Problem](http://www.geeksforgeeks.org/dynamic-programming-set-10-0-1-knapsack-problem/)).

## Solution

Whenever new item comes in you have to decide to pick this item or not and you have to find which gives you the maximum value. If you pick the item the maximum value will the value of the item plus whatever we get by subtracting this value from the total weight and excluding this item or the best you can do without including this item or both.

Lets try solve this problem on two dimensional matrix where total number of columns is the same as `capacityOfBag`+1 and total number of rows is the same as the total `knapsackItems`.

(value) weight | 0 | 1 | 2 | 3 |4 | 5 | 6 | 7
---------------|---|---|---|---|--|---|---|--
(1) 1 | 0 |  |  |  |  |  |  | 
(4) 3 | 0 |  |  |  |  |  |  | 
(5) 4 | 0 |  |  |  |  |  |  | 
(7) 5 | 0 |  |  |  |  |  |  | 




