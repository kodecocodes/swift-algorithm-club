# 蒙提霍尔问题

恭喜！你终于到了最后著名的 [蒙提霍尔游戏节目](https://en.wikipedia.org/wiki/Let%27s_Make_a_Deal)。Monty，节目的主人，让你在三扇门中进行选择。其中一扇门后有一个奖品（一辆新车？一次夏威夷的旅行？一个微波烤箱？），另外两扇门后面是空的。

在你做选择之后，Monty 会让事情变得更有趣一些，他会打开你没有选择的两扇门。当然，他打开的那扇门是空的。现在还有两扇门没打开，在其中一扇后面有让人垂涎欲滴的奖品。

现在 Monty 给你一次更改选择的机会。你是应该继续坚持之前的选择，还是选择另外一扇门，或者这根本无关紧要？

你可能认为改变想法并不会提升你的机会...但是它的确会！

这可能不是一个很直观的结果。可能你认为这不是真的。别担心，当这个问题提出来的时候很多数学专家也不相信，所以你没有站错队。

有一个简单的方法来验证这个观点：我们可以写一个程序来测试它！我们应该要能展示在玩这个游戏多次的时候谁会赢得更多。

下面是代码（参考[playground](MontyHall.playground/Contents.swift)获取完整内容）。首先，我们随机选择一扇门作为有奖品的：

```swift
  let prizeDoor = random(3)
```

同样也随机选择玩家的选择：

```swift
  let chooseDoor = random(3)
```

下一步，Monty 打开一扇空的门。明显地，他不会选择玩家已经选了的或者有奖品的门。

```swift
  var openDoor = -1
  repeat {
    openDoor = random(3)
  } while openDoor == prizeDoor || openDoor == chooseDoor
```  

现在有两扇门还关着，一个有奖品，如果这个时候玩家改变注意选择另外一扇门会发生什么？

```swift
  var changeMind = -1
  repeat {
    changeMind = random(3)
  } while changeMind == openDoor || changeMind == chooseDoor
```

现在我们看看哪个选择是正确的：

```swift
  if chooseDoor == prizeDoor {
    winOriginalChoice += 1
  }
  if changeMind == prizeDoor {
    winChangedMind += 1
  }
```

如果奖品在玩家原来选择的门后面，我们就将 `winOriginalChoice` 加 1。如果奖品是另外的门，那么玩家改变主意的话机会赢，所以就将 `winChangedMind` 加 1。

这就是我们要做的。

如果将上面的代码运行 1000 次，就会发现在不改变主意的情况下获得奖品的概率大概是 33%。但是如果改变主意，赢的概率就是 67% -- 是之前的两倍！

如果你还是不相信的话就在 playground 里试试吧。:-)

下面是原因：当第一次选择的时候，选中奖品的概率是 1/3，或 33%

当 Monty 打开一扇门之后，你就得到了新的信息。然而，它不会改变你原来选择的赢的概率。它还是 33% 因为你是在不知道门后有什么的情况下做的选择。

由于概率加起来总共是 100%，奖品在另外一扇门的概率是 100 - 33 = 67%。所以，听起来可能很奇怪，你最好还是改变主意！

你的脑子可能很难转过弯来，但是很容易通过运行很多次来模拟。概率是奇怪的。

顺便说一下，可以将代码简化为：

```swift
  let prizeDoor = random(3)
  let chooseDoor = random(3)
  if chooseDoor == prizeDoor {
    winOriginalChoice += 1
  } else {
    winChangedMind += 1
  }
```

现在它不再是一个模拟，而是一个逻辑上相等的问题。你可以清楚地看到 `chooseDoor` 只有 1/3 的时候是赢的 -- 因为它是一个 1 到 3 之间的随机数 -- 所以改变主意可以赢得另外的 2/3。

[蒙提霍尔问题 维基百科](https://en.wikipedia.org/wiki/Monty_Hall_problem)

*作者：Matthijs Hollemans 翻译：Daisy*


