import Foundation

/*
  Basic implementation of Huffman encoding. It encodes bytes that occur often
  with a smaller number of bits than bytes that occur less frequently.

  Based on Al Stevens' C Programming column from Dr.Dobb's Magazine, February
  1991 and October 1992.

  Note: This code is not optimized for speed but explanation.
*/
public class Huffman {
  /* Tree nodes don't use pointers to refer to each other, but simple integer
     indices. That allows us to use structs for the nodes. */
  typealias NodeIndex = Int

  /* A node in the compression tree. Leaf nodes represent the actual bytes that
     are present in the input data. The count of an intermediary node is the sum
     of the counts of all nodes below it. The root node's count is the number of
     bytes in the original, uncompressed input data. */
  struct Node {
    var count = 0
    var index: NodeIndex = -1
    var parent: NodeIndex = -1
    var left: NodeIndex = -1
    var right: NodeIndex = -1
  }

  /* The tree structure. The first 256 entries are for the leaf nodes (not all
     of those may be used, depending on the input). We add additional nodes as
     we build the tree. */
  var tree = [Node](count: 256, repeatedValue: Node())

  /* This is the last node we add to the tree. */
  var root: NodeIndex = -1

  /* The frequency table describes how often a byte occurs in the input data.
     You need it to decompress the Huffman-encoded data. The frequency table
     should be serialized along with the compressed data. */
  public struct Freq {
    var byte: UInt8 = 0
    var count = 0
  }

  public init() { }
}

extension Huffman {
  /* To compress a block of data, first we need to count how often each byte
     occurs. These counts are stored in the first 256 nodes in the tree, i.e.
     the leaf nodes. The frequency table used by decompression is derived from
     this. */
  private func countByteFrequency(data: NSData) {
    var ptr = UnsafePointer<UInt8>(data.bytes)
    for _ in 0..<data.length {
      let i = Int(ptr.memory)
      tree[i].count += 1
      tree[i].index = i
      ptr = ptr.successor()
    }
  }

  /* Takes a frequency table and rebuilds the tree. This is the first step of
     decompression. */
  private func restoreTree(frequencyTable: [Freq]) {
    for freq in frequencyTable {
      let i = Int(freq.byte)
      tree[i].count = freq.count
      tree[i].index = i
    }
    buildTree()
  }

  /* Returns the frequency table. This is the first 256 nodes from the tree but
     only those that are actually used, without the parent/left/right pointers.
     You would serialize this along with the compressed file. */
  public func frequencyTable() -> [Freq] {
    var a = [Freq]()
    for i in 0..<256 where tree[i].count > 0 {
      a.append(Freq(byte: UInt8(i), count: tree[i].count))
    }
    return a
  }
}

extension Huffman {
  /* Builds a Huffman tree from a frequency table. */
  private func buildTree() {
    // Create a min-priority queue and enqueue all used nodes.
    var queue = PriorityQueue<Node>(sort: { $0.count < $1.count })
    for node in tree where node.count > 0 {
      queue.enqueue(node)
    }

    while queue.count > 1 {
      // Find the two nodes with the smallest frequencies that do not have
      // a parent node yet.
      let node1 = queue.dequeue()!
      let node2 = queue.dequeue()!

      // Create a new intermediate node.
      var parentNode = Node()
      parentNode.count = node1.count + node2.count
      parentNode.left = node1.index
      parentNode.right = node2.index
      parentNode.index = tree.count
      tree.append(parentNode)

      // Link the two nodes into their new parent node.
      tree[node1.index].parent = parentNode.index
      tree[node2.index].parent = parentNode.index

      // Put the intermediate node back into the queue.
      queue.enqueue(parentNode)
    }

    // The final remaining node in the queue becomes the root of the tree.
    let rootNode = queue.dequeue()!
    root = rootNode.index
  }
}

extension Huffman {
  /* Compresses the contents of an NSData object. */
  public func compressData(data: NSData) -> NSData {
    countByteFrequency(data)
    buildTree()

    let writer = BitWriter()
    var ptr = UnsafePointer<UInt8>(data.bytes)
    for _ in 0..<data.length {
      let c = ptr.memory
      let i = Int(c)
      traverseTree(writer: writer, nodeIndex: i, childIndex: -1)
      ptr = ptr.successor()
    }
    writer.flush()
    return writer.data
  }

  /* Recursively walks the tree from a leaf node up to the root, and then back
     again. If a child is the right node, we emit a 0 bit; if it's the left node,
     we emit a 1 bit. */
  private func traverseTree(writer writer: BitWriter, nodeIndex h: Int, childIndex child: Int) {
    if tree[h].parent != -1 {
      traverseTree(writer: writer, nodeIndex: tree[h].parent, childIndex: h)
    }
    if child != -1 {
      if child == tree[h].left {
        writer.writeBit(true)
      } else if child == tree[h].right {
        writer.writeBit(false)
      }
    }
  }
}

extension Huffman {
  /* Takes a Huffman-compressed NSData object and outputs the uncompressed data. */
  public func decompressData(data: NSData, frequencyTable: [Freq]) -> NSData {
    restoreTree(frequencyTable)

    let reader = BitReader(data: data)
    let outData = NSMutableData()
    let byteCount = tree[root].count

    var i = 0
    while i < byteCount {
      var b = findLeafNode(reader: reader, nodeIndex: root)
      outData.appendBytes(&b, length: 1)
      i += 1
    }
    return outData
  }

  /* Walks the tree from the root down to the leaf node. At every node, read the
     next bit and use that to determine whether to step to the left or right.
     When we get to the leaf node, we simply return its index, which is equal to
     the original byte value. */
  private func findLeafNode(reader reader: BitReader, nodeIndex: Int) -> UInt8 {
    var h = nodeIndex
    while tree[h].right != -1 {
      if reader.readBit() {
        h = tree[h].left
      } else {
        h = tree[h].right
      }
    }
    return UInt8(h)
  }
}
