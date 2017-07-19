# Encode and Decode Binary Tree

We need to design an algorithm to encode and decode a binary tree. 
* **Encode**: Convert a tree into a string that can be stored in the disk.
* **Decode**: Given the encoded string, you need to convert it into a Tree.

For example, you may serialize the following tree


as "[1,2,3,null,null,4,5]", just the same as how LeetCode OJ serializes a binary tree. You do not necessarily need to follow this format, so please be creative and come up with different approaches yourself.
Note: Do not use class member/global/static variables to store states. Your serialize and deserialize algorithms should be stateless.

## Solution
For example, given a tree like this
>       a
>      /  \\
>
>    b     c
>
>    ​      /  \\
>    ​    d    e

We can use inorder traversal to convert the tree into the string like this `a b # # c d # # e # #`

So, the idea is for the empty node, we use `#` to represent.

For the decode process, we can still use inorder to convert the string back to a tree.