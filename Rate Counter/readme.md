# Rate Counter

Design a rate counter to get the total count in a time range.

This counter will have to functions.

* **hit(timestamp: Int)** -> In this timestamp, the counter has been hitted once.
* **getCount(timestamp: Int)** -> Return ended by timestamp 300s total hit count. In another word, the time range is [timestamp - 299, timestamp], return sum of hits in this range.

We can assume that when we call getCount, the timestamp is current timestamp. That means if we call getCount(300), we won't call getCount(299) any more.


## Solution

### Simple Version

We can use a hash map to record all timestamp count. When we call getCount(timestamp), we need to compare hash map key with time range. Make sure (timestamp - 299) <= key and key <= timestamp then we count it. 

### Clean up Version

We notice actually, when we query getCount(), the timestamp passes in is current time. So, we won't query the timestamp long time ago. That means we waste a lot of memory to store the past data. Is there a way to address this issue? We can clean up the out of data when we query the getCount(). Just need to make sure all key < timestamp - 299 will be removed. Then the average space is kind of O(300).

### Array Version

For clean up version, in the worst case, we don't call getCount() often, we still occupy a lot of old data. Since clean up cannot be called without calling getCount(). So, how we can fix this?

Could we use exactly O(300) space?

The only way to address this is we do something when we call hit(). If we allocate O(300) array, we have `0..299` spot to store the data. If given a timestamp, how we place it. Maybe you got the idea, right? It's like hash table. We call `let index = timestamp % 300` to get the spot index. But how about case like this 300 and 600 occupy the same spot, there will be conflict. Maybe you notice, when we call getCount() we pass the current timestamp, so that means when we hit(600) the current timestamp is 600. So, 300 does not matter any more. We can just drop it. Yaya, problem solved. Last issue is how we know which timestamp the current spot has. We can create another array keys[300] to record this.
