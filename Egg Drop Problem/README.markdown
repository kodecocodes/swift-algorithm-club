#Egg Drop Dynamic Problem

#Problem Description 

Given some number of floors and some number of eggs, what is the minimum number of attempts it will take to find out from which floor egg will break.

Suppose that we wish to know which stories in a 36-story building are safe to drop eggs from, and which will cause the eggs to break on landing. We make a few assumptions:

- An egg that survives a fall can be used again.
- A broken egg must be discarded.
- The effect of a fall is the same for all eggs.
- If an egg breaks when dropped, then it would break if dropped from a higher floor.
- If an egg survives a fall then it would survive a shorter fall.

If only one egg is available and we wish to be sure of obtaining the right result, the experiment can be carried out in only one way. Drop the egg from the first-floor window; if it survives, drop it from the second floor window. Continue upward until it breaks. In the worst case, this method may require 36 droppings. Suppose 2 eggs are available. What is the least number of egg-droppings that is guaranteed to work in all cases?
The problem is not actually to find the critical floor, but merely to decide floors from which eggs should be dropped so that total number of trials are minimized.

#Solution
- eggNumber -> Number of eggs at the moment
- floorNumber -> Floor number at the moment
- visitingFloor -> Floor being visited at the moment
- attempts -> Minimum number of attempts it will take to find out from which floor egg will break

We store all the solutions in a 2D array. Where rows represents number of eggs and columns represent number of floors. 

First, we set base cases:
1) If there's only one egg, it takes as many attempts as number of floors
2) If there's are two eggs and one floor, it takes one attempt

```swift
for var floorNumber in (0..<(numberOfFloors+1)){
eggFloor[1][floorNumber] = floorNumber      //base case 1: if there's only one egg, it takes 'numberOfFloors' attempts
}

eggFloor[2][1] = 1 //base case 2: if there are two eggs and one floor, it takes one attempt
```

When we drop an egg from a floor 'floorNumber', there can be two cases (1) The egg breaks (2) The egg doesn’t break.

1) If the egg breaks after dropping from 'visitingFloorth' floor, then we only need to check for floors lower than 'visitingFloor' with remaining eggs; so the problem reduces to 'visitingFloor'-1 floors and 'eggNumber'-1 eggs.
2) If the egg doesn’t break after dropping from the 'visitingFloorth' floor, then we only need to check for floors higher than 'visitingFloor'; so the problem reduces to floors-'visitingFloor' floors and 'eggNumber' eggs.

Since we need to minimize the number of trials in worst case, we take the maximum of two cases. We consider the max of above two cases for every floor and choose the floor which yields minimum number of trials.

We find the answer based on the base cases and previously found answers as follows. 
```swift
attempts = 1 + max(eggFloor[eggNumber-1][floors-1], eggFloor[eggNumber][floorNumber-floors])//we add one taking into account the attempt we're taking at the moment

if attempts < eggFloor[eggNumber][floorNumber]{ //finding the min
    eggFloor[eggNumber][floorNumber] = attempts;
}
```
