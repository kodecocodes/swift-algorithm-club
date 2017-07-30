# Merge K Sorted Lists

Merge k sorted linked lists and return it as one sorted list.

## Solution 1 - Brute Force

Every time pick first 2 lists and merge them to one sorted list. Repeat these steps until there is only 1 list.
The bottleneck of this solution is the first list will become longer and longer each time. We need to keep loop it every time.
Let's assume each list's length is `n`, then the first list will be iterated `k-1` times, and second `k-2`, third `k-3` etc.
So total time complexity will be `(k-1) * n + (k-2) * n + (k-3) * n + ... + n` = `O(n * (1 - n^k) / (1 - n))`

## Solution 2 - Merge Sort

Use merge sort idea, each time merge(beg, mid) and merge(mid + 1, end), then finally merge their results.
Time complexity will be `O(kn*log(kn))`, much better.

## Solution 3 - Heap

First, get the first element from each list and insert a min heap. Pop up the top element from min heap and insert into final
list. Let's assume the top element is from list A. Then we need to insert the next element from list A into min heap.
Repeat the same step. Until all elements have been inserted into our final list.

The heap size will be `O(k)`. We need to do `k * n` times insert and pop. So the time complexity is `O(kn * logk)`.
