# Changes

- Corrected a spelling error in a comment.

- Got rid of the `get` syntax for a read only property as the coding guidelines suggest.

- Changed several tests so that they are more Swift-like.  That is, they now feel like they are using the features of the language better.

- Fixed a problem in the test method `testRemovePerformance`.  The `measure` method runs the block of code 10 times.  Previously, all words would get removed after the first run and the next 9 runs were very fast because there was nothing to do!  That is corrected now.

- Made the `Trie` class a subclass of `NSObject` and had it conform to `NSCoding`.  Added a test to verify that this works.

---

I wasn't able to figure out how to recursively archive the trie.  Instead, I tried Kelvin's suggestion to use the `words` property to create an array of words in the trie, then archiving the array.

There are a couple of nice aspects to this approach.

- The `TrieNode` class can remain generic since it doesn't need to conform to `NSCoding`.

- It doesn't require much new code.

There are several downsides though.

- The size of the archived words is three times the size of the original file of words!  Did I do this right?  The tests pass, so it seems correct.  I question whether archiving is worth the effort if the resulting archive is so much larger than the original file.

- I would expect that archiving the trie would result in a file that was smaller than the original since a trie doesn't repeat leading character sequences when they are the same.

- This requires that the trie get reconstructed when it is unarchived.

- My gut tells me that it would be faster to archive and unarchive the trie itself, but I don't have any hard data to support this.

I would like to see code that recursively archives the trie so we can compare the performance.
