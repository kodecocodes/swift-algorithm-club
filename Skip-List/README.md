# Skip List

Skip List is a probablistic data-structure with same efficiency as AVL tree or Red-Black tree. The building blocks are hierarchy of layers (regular sorted linked-lists), created probablisticly by coin flipping, each acting as an express lane to the layer underneath, therefore making fast O(log n) search possible by skipping lanes. A layer consists of a Head node, holding reference to the subsequent and the node below. Each node also holds similar references as the Head node.

#TODO
 - finish readme
