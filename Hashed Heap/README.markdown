# Hashed Heap

A hashed heap is a [heap](../Heap/) with a hash map (also known as a dictionary) to speed up lookup of elements by value. This combination doesn't compromize on time performance but requires extra storage for the hash map. This is mainly used for heuristic search algorihms, in particular A*.

## The code

See [HashedHeap.swift](HashedHeap.swift) for the implementation. See [Heap](../Heap/) for a detailed explanation of the basic heap implementation.

## See also

[Heap on Wikipedia](https://en.wikipedia.org/wiki/Heap_%28data_structure%29)

*Written for the Swift Algorithm Club by [Alejandro Isaza](https://github.com/aleph7)*
