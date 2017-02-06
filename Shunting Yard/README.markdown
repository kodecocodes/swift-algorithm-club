# Shunting Yard Algorithm

Any mathematics we write is expressed in a notation known as *infix notation*. For example:

**A + B * C**

The operator is placed in between the operands, hence the expression is said to be in *infix* form. If you think about it, any expression that you write on a piece of paper will always be in infix form. This is what we humans understand.

Multiplication has higher precedence than addition, so when the above expression is evaluated you would first multiply **B** and **C**, and then add the result to **A**. We humans can easily understand the precedence of operators, but a machine needs to be given instructions about each operator.

To change the order of evaluation, we can use parentheses:

**(A + B) * C**

Now **A** is first added to **B** and then the sum is multiplied by **C**.

If you were to write an algorithm that parsed and evaluated expressions in infix notation you will realize that it's a tedious process. You'd have to parse the expression multiple times to know what operation to perform first. As the number of operators increase so does the complexity.

## Postfix notation

In postfix notation, also known as Reverse Polish Notation or RPN, the operators come after the corresponding operands. Here is the postfix representation of the example from the previous section:

**A B C * +**

An expression in postfix form will not have any parentheses and neither will you have to worry about scanning for operator precedence. This makes it easy for the computer to evaluate expressions, since the order in which the operators need to be applied is fixed.

Evaluating a postfix expression is easily done using a stack. Here is the pseudocode:

1. Read the postfix expression token by token
2. If the token is an operand, push it onto the stack
3. If the token is a binary operator,
    1. Pop the two topmost operands from the stack
    2. Apply the binary operator to the two operands
    3. Push the result back onto the stack
4. Finally, the value of the whole postfix expression remains in the stack

Using the above pseudocode, the evaluation of **A B C * +** would be as follows:

| Expression    | Stack   |
| ------------- | --------|
| A B C * +     |         |
| B C * +       | A       |
| C * +         | A, B    |
| * +           | A, B, C |
| +             | A, D    |
|               | E       |

Where **D = B * C** and **E = A + D.**

As seen above, a postfix operation is relatively easy to evaluate as the order in which the operators need to be applied is pre-decided.

## Converting infix to postfix

The shunting yard algorithm was invented by Edsger Dijkstra to convert an infix expression to postfix. Many calculators use this algorithm to convert the expression being entered to postfix form.

Here is the psedocode of the algorithm:

1. For all the input tokens:
    1. Read the next token
    2. If token is an operator (x)
        1. While there is an operator (y) at the top of the operators stack and either (x) is left-associative and its precedence is less or equal to that of (y), or (x) is right-associative and its precedence is less than (y)
            1. Pop (y) from the stack
            2. Add (y) output buffer
        2. Push (x) on the stack
    3. Else if token is left parenthesis, then push it on the stack
    4. Else if token is a right parenthesis
        1. Until the top token (from the stack) is left parenthesis, pop from the stack to the output buffer
        2. Also pop the left parenthesis but don’t include it in the output buffer
    7. Else add token to output buffer
2. Pop any remaining operator tokens from the stack to the output

Let's take a small example and see how the pseudocode works. Here is the infix expression to convert:

**4 + 4 * 2 / ( 1 - 5 )**

The following table describes the precedence and the associativity for each operator. The same values are used in the algorithm.

| Operator | Precedence   | Associativity   |
| ---------| -------------| ----------------|
| ^        | 10           | Right           |
| *        | 5            | Left            |
| /        | 5            | Left            |
| +        | 0            | Left            |
| -        | 0            | Left            |

Here we go:

| Token | Action                                      | Output            | Operator stack |
|-------|---------------------------------------------|-------------------|----------------|
| 4     | Add token to output                         | 4                 |                |
| +     | Push token to stack                         | 4                 | +              |
| 4     | Add token to output                         | 4 4               | +              |
| *     | Push token to stack                         | 4 4               | * +            |
| 2     | Add token to output                         | 4 4 2             | * +            |
| /     | Pop stack to output, Push token to stack | 4 4 2 *           | / +            |
| (     | Push token to stack                         | 4 4 2 *           | ( / +          |
| 1     | Add token to output                         | 4 4 2 * 1         | ( / +          |
| -     | Push token to stack                         | 4 4 2 * 1         | - ( / +        |
| 5     | Add token to output                         | 4 4 2 * 1 5       | - ( / +        |
| )     | Pop stack to output, Pop stack           | 4 4 2 * 1 5 -     | /  +           |
| end   | Pop entire stack to output                  | 4 4 2 * 1 5 - / + |                |

We end up with the postfix expression:

**4 4 2 * 1 5 - / +**

# See also

[Shunting yard algorithm on Wikipedia](https://en.wikipedia.org/wiki/Shunting-yard_algorithm)

*Written for the Swift Algorithm Club by [Ali Hafizji](http://www.github.com/aliHafizji)*
*Migrated to Swift 3 by Jaap Wijnen*
