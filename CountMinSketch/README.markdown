# CountMin Sketch

#### Explanation about the model (Taken from wikipedia)
In computing, the count–min sketch (CM sketch) is a probabilistic data structure that serves as a frequency table of events in a stream of data. It uses hash functions to map events to frequencies, but unlike a hash table uses only sub-linear space, at the expense of overcounting some events due to collisions. The count–min sketch was invented in 2003 by Graham Cormode and S. Muthu Muthukrishnan and described by them in a [2005 paper](https://www.sciencedirect.com/science/article/abs/pii/S0196677403001913?via%3Dihub).

The goal of the basic version of the count–min sketch is to consume a stream of events, one at a time, and count the frequency of the different types of events in the stream. At any time, the sketch can be queried for the frequency of a particular event type i from a universe of event types {U}, and will return an estimate of this frequency that is within a certain distance of the true frequency, with a certain probability.

The actual sketch data structure is a two-dimensional array of w columns and d rows. The parameters w and d are fixed when the sketch is created, and determine the time and space needs and the probability of error when the sketch is queried for a frequency or inner product. Associated with each of the d rows is a separate hash function; the hash functions must be pairwise independent. The parameters w and d can be chosen by setting w = ⌈2/ε⌉ and d = ⌈ln 1/δ⌉, where the error in answering a query is within an additive factor of ε with probability 1 − δ
When a new event of type i arrives we update as follows: for each row j of the table, apply the corresponding hash function to obtain a column index k = hj(i). Then increment the value in row j, column k by one.

![algorithm](Images/algorithm.png "Algorithm and main Data Structure")
![matrix_def](Images/matrix_def.png "Matrix size and definitions")


#### Implementation details
1. Memory consumption - We hold a matrix in the size according to the probalictic charactaristic the user wish, specifically we will have cols = ⌈2/ε⌉ and row = ⌈ln 1/δ⌉
2. `add` function - Given the assumption applying a hash function takes O(1) as well as arithmetic addition `adding` an element shall take O(⌈ln 1/δ⌉) = O(number of rows)
3. `query` - Same as adding - O(⌈ln 1/δ⌉) = O(number of rows)


#### How is this different from a regular counter
This model allows us to use sublinear space to estimate the frequecny of elements if a stream.
While a regualr counter will have to maintain some mapping between each element to its frequency, this model allows us to use probability and have a smaller memory footprint.
This value of this Data Structure makes it particulary benefitial for huge data streams where it is not feasable to hold an exact counter for each elements as the stream is potentially endless. 


*Written by Daniel Bachar*
