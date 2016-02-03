# Mergesort

Goal: Sort an array from low to high (or high to low)

Invented in 1945, mergesort is a fairly efficient sorting algorithm with a best, worst, and average time complexity of O(n log n). The idea behind Mergesort
is to **divide and conquer**. I'd like to call it **split first** and **merge after**. Assume you're given an array of numbers and you need to put them in the right order. The merge sort algorithm works as follows:

- Put the numbers in a pile. The pile is unsorted.
- Split the pile into 2. Now you have **two unsorted piles** of numbers.
- Keep splitting the resulting piles until you can't anymore; In the end, you will have *n* piles with 1 number in each pile
- Begin to **merge** the piles together by sequentially pairing a pile with another pile. During each merge, you want to sort the contents in order



