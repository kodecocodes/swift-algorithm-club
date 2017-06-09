# Algorithm design techniques

What to do when you're faced with a new problem and you need to find an algorithm for it.

### Is it similar to another problem?

If you can frame your problem in terms of another, more general problem, then you might be able to use an existing algorithm. Why reinvent the wheel?

One thing I like about [The Algorithm Design Manual](http://www.algorist.com) by Steven Skiena is that it includes a catalog of problems and solutions you can try. (See also his [algorithm repository](http://www3.cs.stonybrook.edu/~algorith/).)

### It's OK to start with brute force

Naive, brute force solutions are often too slow for practical use but they're a good starting point. By writing the brute force solution, you learn to understand what the problem is really all about.

Once you have a brute force implementation you can use that to verify that any improvements you come up with are correct. 

And if you only work with small datasets, then a brute force approach may actually be good enough on its own. Don't fall into the trap of premature optimization!

### Divide and conquer

>"When you change the way you look at things, the things you look at change."</br>
>Max Planck, Quantum theorist and Nobel Prize Winner

Divide and conquer is a way of dealing with a large problem by breaking it down into bits and pieces and working your way up towards the solution.

Instead of seeing the whole problem as a single, huge and complex task you divide the problem in relatively smaller problems that are easier to understand and deal with.

You solve smaller problems and aggregate the solution until you are left with the solution only. At each step the problem at hand shrinks and the solution gets mature until you have the final correct solution.

Solving the smaller task and applying the same solution repetitively ( or often times recursively) to other chunks give you the result in less time.
