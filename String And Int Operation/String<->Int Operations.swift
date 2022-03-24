import UIKit
extension String {
    // a -> 10
    var hexToInt : Int{return Int(strtoul(self, nil, 16))}
    // a -> 10.0
    var hexToDouble : Double{return Double(strtoul(self, nil, 16))}
    // a -> 1010
    var hexToBin : String{return String(hexToInt, radix: 2)}
    // 10 -> a
    var intToHex : String{ return String(Int(self) ?? 0, radix: 16)}
    // 10 -> 1010
    var intToBin : String{return String(Int(self) ?? 0, radix: 2)}
    // 1010 -> 10
    var binToInt : Int{return Int(strtoul(self, nil, 2))}
    // 1010 -> 10.0
    var binToDouble : Double{return Double(strtoul(self, nil, 2))}
    // 1010 -> a
    var binToHexa : String{return String(binToInt, radix: 16)}
    // a -> 97
    var ascii : Int{return Int(self.unicodeScalars.first!.value)}
}
extension Int {
    // 10 -> 1010
    var binString : String{return String(self, radix: 2)}
    // 10 -> a
    var hexString : String{return String(self, radix: 16)}
    // 10 -> 10.0
    var double : Double{ return Double(self)}
    // 97 -> a
    var intToAscii : String{return String(Character(UnicodeScalar(self)!))}
}
