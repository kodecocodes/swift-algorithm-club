# Bucket Sort

## Definition
[Bucket Sort or Bin Sort](https://en.wikipedia.org/wiki/Bucket_sort) is a distributed sorting algorithm, which sort elements from an array by performing these steps:  

1) Distribute the elements into buckets or bin.  
2) Sort each bucket individually.  
3) Merge the buckets in order to produce a sort array as results.  

A more complete definition could be

>
Bucket sort, or bin sort, is a sorting algorithm that works by distributing the elements of an array into a number of buckets. Each bucket is then sorted individually, either using a different sorting algorithm, or by recursively applying the bucket sorting algorithm. It is a distribution sort, and is a cousin of radix sort in the most to least significant digit flavour. Bucket sort is a generalization of pigeonhole sort. Bucket sort can be implemented with comparisons and therefore can also be considered a comparison sort algorithm. The computational complexity estimates involve the number of buckets. [1](https://en.wikipedia.org/wiki/Bucket_sort)

## Performance

Performance for execution time:  
  
| Case  | Performance |
|:-------------: |:---------------:|
| Worst       |  O(n^2) |
| Best      | 	Omega(n + k)        |
|  Average | 	Theta(n + k)       | 
  
Where **n** = #elements and **k** = #buckets  


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

### Custom Sorter and Distributor

The current implementation make use of the following implementations for *Sorter* and *Distributor*.  

*Sorter*  

    public struct InsertionSorter: Sorter {
    
        public init() {}
    
        public func sort<T:Sortable>(items: [T]) -> [T] {
            var results = items
            for i in 0 ..< results.count {
                var j = i
                while ( j > 0 && results[j-1] > results[j]) {
                
                    let auxiliar = results[j-1]
                    results[j-1] = results[j]
                    results[j] = auxiliar
                
                    j -= 1
                }
            }
            return results
        }
    }

*Distributor*  

    /*
    * An example of a simple distribution function that send every elements to
    * the bucket representing the range in which it fits.An
    *
    * If the range of values to sort is 0..<49 i.e, there could be 5 buckets of capacity = 10
    * So every element will be classified by the ranges:
    *
    * -  0 ..< 10
    * - 10 ..< 20
    * - 20 ..< 30
    * - 30 ..< 40
    * - 40 ..< 50
    *
    * By following the formula: element / capacity = #ofBucket
    */
    public struct RangeDistributor: Distributor {
    
         public init() {}
    
         public func distribute<T:Sortable>(element: T, inout buckets: [Bucket<T>]) {
         let value = element.toInt()
         let bucketCapacity = buckets.first!.capacity
        
         let bucketIndex = value / bucketCapacity
         buckets[bucketIndex].add(element)
        }
    }

### Make your own version

By reusing this code and implementing your own *Sorter* and *Distributor* you can experiment with different versions.

## Other variations of Bucket Sort

The following are some of the variation to the General Bucket Sort implemented here:

- [Proxmap Sort](https://en.wikipedia.org/wiki/Bucket_sort#ProxmapSort)
- [Histogram Sort](https://en.wikipedia.org/wiki/Bucket_sort#Histogram_sort)
- [Postman Sort](https://en.wikipedia.org/wiki/Bucket_sort#Postman.27s_sort)
- [Shuffle Sort](https://en.wikipedia.org/wiki/Bucket_sort#Shuffle_sort)

