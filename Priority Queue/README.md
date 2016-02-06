# Priority Queue

Priority Queue is a kind of Binary Heap and it has similar operations like Queue data structure but instead Items are sorted based on their `priority`.

In this case, our queue is min-priority oriented and uses Minimum Heap properties.

# Properties

Priority Queue uses an Array internally which starts at index 1.

for every index in the Array:

 left child is index * 2

 right child is (index * 2) + 1

 parent is floor(index/2)

Parents must have priority value lesser than their childs.


