// The MIT License (MIT)

// Copyright (c) 2016 Mike Taghavi (mitghi[at]me.com)

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

class PriorityQueue{
    var heap: [Int] = [0]
    var currentSize: Int = 0

    enum Direction { case UP,DOWN }

    func insert(item: Int){
        heap.append(item)
        currentSize += 1
        heapify(currentSize,direction:.UP)
    }

    private func heapify(size: Int,direction: Direction){
        switch direction{
        case .UP:
            var i = size
            while i / 2 > 0 {
                if heap[i] < heap[i/2]{
                    let temp = heap[i]
                    heap[i] = heap[i/2]
                    heap[i/2] = temp
                }
                i /= 2
            }
        case .DOWN:
            var i = size
            while i*2 <= currentSize {
                let min_child = minChild(i)
                if heap[i] > heap[min_child]{
                    let temp = heap[i]
                    heap[i] = heap[min_child]
                    heap[min_child] = temp
                }
                i = min_child
            }
        }
    }

    private func minChild(currentChild: Int) -> Int{
        if currentChild * 2 + 1 > currentSize { return currentChild * 2 }            
        else {
            if heap[currentChild * 2] < heap[(currentChild * 2) + 1] { return currentChild * 2 }
            else { return (currentChild * 2) + 1 }
        }
    }

    func pop() -> Int? {
        if heap.count < 2 { return nil }
        
        let item: Int? = heap.removeAtIndex(1)
        currentSize -= 1

        if currentSize > 1 {
            heap.insert(heap.removeLast(),atIndex:1)
            heapify(1,direction:.DOWN)
        }
        
        return item
    }
}
