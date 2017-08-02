// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

var numberList = [1, 12, 9, 17, 13, 12]

slowsort(0, numberList.count-1, &numberList)
print(numberList)
