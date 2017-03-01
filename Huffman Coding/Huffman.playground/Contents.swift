//: Playground - noun: a place where people can play

import Foundation

let s1 = "so much words wow many compression"
if let originalData = s1.data(using: .utf8) {
  print(originalData.count)

  let huffman1 = Huffman()
  let compressedData = huffman1.compressData(data: originalData as NSData)
  print(compressedData.length)

  let frequencyTable = huffman1.frequencyTable()
  //print(frequencyTable)

  let huffman2 = Huffman()
  let decompressedData = huffman2.decompressData(data: compressedData, frequencyTable: frequencyTable)
  print(decompressedData.length)

  let s2 = String(data: decompressedData as Data, encoding: .utf8)!
  print(s2)
  assert(s1 == s2)
}
