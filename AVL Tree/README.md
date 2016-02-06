# AVL tree

AVL tree is a self balancing form of Binary Tree in which height of subtrees differ at most by only 1.


# Properties 

A subtree dissatisfies AVL tree properties -- if `balance` factor is greater than `1` or lesser than `-1` 
where the balance factor is defined as following:

    balance = height(left_subtree) − height(right_subtree)
    
                  (12/b:-2)           
                        \
                         \
                     (13/b:-1)        
                           \
                            \
                        (14/b:0)       

# Searching and Inserting

Searching is done through a recursive function which searches the tree from top-down based on Binary Tree rules.

Inserting into the tree is similar to Binary Tree but differs by one additional opeartion which updates the `balance` variable.


# See also
[AVL tree on Wikipedia](https://en.wikipedia.org/wiki/AVL_tree)

*Written by Mike Taghavi*
