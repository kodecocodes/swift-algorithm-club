# The Monty Hall Problem

Congrats! You've reached the final round of the popular [Monty Hall game show](https://en.wikipedia.org/wiki/Let%27s_Make_a_Deal). Monty, the show host, gives you the choice between 3 doors. Behind one of the doors is a prize (a new car? a trip to Hawaii? a microwave oven?), the other two are empty.

After you make your choice, Monty decides to make things a bit more interesting and opens one of the two doors that you didn't pick. Of course, the one he opens is empty. There are now two doors left, behind one of which is the coveted prize.

Now Monty gives you the opportunity to change your mind. Should you stick with your original choice, should you pick the other door, or doesn't it matter?

You'd think that changing your answer wouldn't improve your chances... but it does!

This is a very nonintuitive result. Maybe you have trouble believing this is true. Don't worry, when this problem was first proposed many professional mathematicians didn't believe it either, so you're in good company.

There's a simple way to verify this claim: we can write a program to test it out! We should be able to show who wins more often by playing the game a large number of times.

Here's the code (see the [playground](MontyHall.playground/Contents.swift) for the full thing). First, we randomly choose the door that has the prize:

```swift
  let prizeDoor = random(3)
```

We also randomly pick the choice of the player:

```swift
  let chooseDoor = random(3)
```

Next, Monty opens one of the empty doors. Obviously, he won't choose the door that the player chose or the one with the prize.

```swift
  var openDoor = -1
  repeat {
    openDoor = random(3)
  } while openDoor == prizeDoor || openDoor == chooseDoor
```  

There are only two closed doors left, one of which has the prize. What happens when the player changes his mind and picks the other door?

```swift
  var changeMind = -1
  repeat {
    changeMind = random(3)
  } while changeMind == openDoor || changeMind == chooseDoor
```

Now we see which choice was the right one:

```swift
  if chooseDoor == prizeDoor {
    winOriginalChoice += 1
  }
  if changeMind == prizeDoor {
    winChangedMind += 1
  }
```

If the prize is behind the player's original door choice, we increment `winOriginalChoice`. If the prize is behind the other door, then the player would have won if he changed his mind, and so we increment `winChangedMind`.

And that's all there is to it.

If you run the above code 1000 times or so, you'll find that the probability of choosing the prize without changing your mind is about 33%. But if you *do* change your mind, the probability of winning is 67% -- that is twice as large!

Try it out in the playground if you still don't believe it. ;-)

Here's why: When you first make a choice, your chances of picking the prize are 1 out of 3, or 33%

After Monty opens one of the doors, this gives you new information. However, it doesn't change the probability of your original choice being the winner. That chance remains 33% because you made that choice when you didn't know yet what was behind this open door.

Since probabilities always need to add up to 100%, the chance that the prize is behind the other door is now 100 - 33 = 67%. So, as strange as it may sound, you're better off switching doors!

This is hard to wrap your head around, but easily shown using a simulation that runs a significant number of times. Probability is weird.

By the way, you can simplify the code to this:

```swift
  let prizeDoor = random(3)
  let chooseDoor = random(3)
  if chooseDoor == prizeDoor {
    winOriginalChoice += 1
  } else {
    winChangedMind += 1
  }
```

Now it's no longer a simulation but the logic is equivalent. You can clearly see that the `chooseDoor` only wins 1/3rd of the time -- because it's a random number between 1 and 3 -- so changing your mind must win the other 2/3rds of the time.

[Monty Hall Problem on Wikipedia](https://en.wikipedia.org/wiki/Monty_Hall_problem)

*Written for Swift Algorithm Club by Matthijs Hollemans*
