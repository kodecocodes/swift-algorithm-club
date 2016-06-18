//: Playground - noun: a place where people can play

import Foundation

let s1 = "so much words wow many compression"
if let originalData = s1.dataUsingEncoding(NSUTF8StringEncoding) {
  print(originalData.length)

  let huffman1 = Huffman()
  let compressedData = huffman1.compressData(originalData)
  print(compressedData.length)

  let frequencyTable = huffman1.frequencyTable()
  //print(frequencyTable)

  let huffman2 = Huffman()
  let decompressedData = huffman2.decompressData(compressedData, frequencyTable: frequencyTable)
  print(decompressedData.length)

  let s2 = String(data: decompressedData, encoding: NSUTF8StringEncoding)!
  print(s2)
  assert(s1 == s2)
}
