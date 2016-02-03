# Mergesort

Goal: Sort an array from low to high (or high to low)

Invented in 1945, mergesort is a fairly efficient sorting algorithm with a best, worst, and average time complexity of O(n log n). The idea behind Mergesort
is to **divide and conquer**; To divide a big problem into smaller chunks and solving many small problems instead of solving a big one. I think of mergesort as **split first** and **merge after**. Assume you're given an array of *n* numbers and you need to put them in the right order. The merge sort algorithm works as follows:

- Put the numbers in a pile. The pile is unsorted.
- Split the pile into 2. Now you have **two unsorted piles** of numbers.
- Keep splitting the resulting piles until you can't anymore; In the end, you will have *n* piles with 1 number in each pile
- Begin to **merge** the piles together by sequentially pairing a pile with another pile. During each merge, you want to sort the contents in order

### An example

Let's say the numbers to sort are `[1, 7, 4 , 5, 9]`. This is your unsorted pile. Our goal is to keep splitting the pile until you can't anymore. 

Split the array into two halves - `[1, 7,]` and `[4, 5, 9]`. Can you keep splitting them? Yes you can!

Focus on the left pile. `[1, 7]` will split into `[1]` and `[7]`. Can you keep splitting them? No. Time to check the other pile.

`[4, 5, 9]` splits to `[4]` and `[5, 9]`. Unsurprisingly, `[4]` can't split into anymore, but `[5, 9]` splits into `[5]` and `[9]`. 

The splitting process ends with the following piles:

`[1]` `[7]` `[4]` `[5]` `[9]`