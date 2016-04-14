# Bucket Sort

## Definition
[Bucket Sort or Bin Sort](https://en.wikipedia.org/wiki/Bucket_sort) is a distributed sorting algorithm, which sort elements from an array by performing these steps:  

1) Distribute the elements into buckets or bin.  
2) Sort each bucket individually.  
3) Merge the buckets in order to produce a sort array as results.  

A more complete definition could be

>
Bucket sort, or bin sort, is a sorting algorithm that works by distributing the elements of an array into a number of buckets. Each bucket is then sorted individually, either using a different sorting algorithm, or by recursively applying the bucket sorting algorithm. It is a distribution sort, and is a cousin of radix sort in the most to least significant digit flavour. Bucket sort is a generalization of pigeonhole sort. Bucket sort can be implemented with comparisons and therefore can also be considered a comparison sort algorithm. The computational complexity estimates involve the number of buckets. [1](https://en.wikipedia.org/wiki/Bucket_sort)


## Pseudocode

A [pseudocode](https://en.wikipedia.org/wiki/Bucket_sort#Pseudocode) of the algorithm is as follows:  

    function bucketSort(array, n) is
        buckets ← new array of n empty lists
        for i = 0 to (length(array)-1) do
            insert array[i] into buckets[msbits(array[i], k)]
        for i = 0 to n - 1 do
            nextSort(buckets[i]);
        return the concatenation of buckets[0], ...., buckets[n-1]


## Graphically explained

###Distribute elements in buckets  

![distribution step](https://upload.wikimedia.org/wikipedia/commons/6/61/Bucket_sort_1.png)

###Sorting inside every bucket and merging  

![sorting each bucket and merge](https://upload.wikimedia.org/wikipedia/commons/3/39/Bucket_sort_2.png)

##Swift implementation

###Classes

![classes](https://github.com/barbaramartina/swift-algorithm-club/blob/BucketSort/Bucket%20Sort/Docs/BucketSort.png)

###Code

Bucket Sort implementation use the following functions, data structures and protocols:

####Main function

`bucketSort` is a generic function that can apply the algorithm to any element of type T, as long as T is Sortable.

    public func bucketSort<T:Sortable>(elements: [T], distributor: Distributor,sorter: Sorter, buckets: [Bucket<T>]) -> [T] {
        precondition(allPositiveNumbers(elements))
        precondition(enoughSpaceInBuckets(buckets, elements: elements))
    
        var bucketsCopy = buckets
        for elem in elements {
            distributor.distribute(elem, buckets: &bucketsCopy)
         }
    
        var results = [T]()
    
       for bucket in bucketsCopy {
            results += bucket.sort(sorter)
        }
    
        return results
     }


####Bucket

    public struct Bucket<T:Sortable> {
        var elements: [T]
        let capacity: Int
    
        public init(capacity: Int) {
            self.capacity = capacity
            elements = [T]()
        }
    
        public mutating func add(item: T) {
            if (elements.count < capacity) {
                elements.append(item)
            }
         }
    
         public func sort(algorithm: Sorter) -> [T] {
            return algorithm.sort(elements)
         }
    }

####Sortable

    public protocol Sortable: IntConvertible, Comparable {
    }

####IntConvertible

The algorithm is designed to sort integers, so all the elements to be sorted should be mapped to an integer value.

    public protocol IntConvertible {
        func toInt() -> Int
    }


####Sorter

    public protocol Sorter {
        func sort<T:Sortable>(items: [T]) -> [T]
    }

####Distributor

    public protocol Distributor {
        func distribute<T:Sortable>(element: T, inout buckets: [Bucket<T>])
    }



