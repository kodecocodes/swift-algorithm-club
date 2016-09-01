# Skip List

Skip List is a probablistic data-structure with same efficiency as AVL tree or Red-Black tree. Fast searching is possible by building a hierarchy of sorted linked-lists acting as an express lane to the layer underneath. Layers are created on top of the base layer ( regular sorted linked-list ) probablisticly by coin-flipping.

A layer consists of a Head node, holding reference to the next and the node below. Each node has also same references similar to the Head node.

#TODO
 - finish readme
