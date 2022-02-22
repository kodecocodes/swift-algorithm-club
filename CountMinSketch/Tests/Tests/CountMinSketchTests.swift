import XCTest


class CountMinSketchTests: XCTestCase {
    
    func testZeroInit() {
        let sketch = CountMinSketch<String>(delta: 0.01, epsilon: 0.01)
        let elements = ["", "1", "b"]
        for element in elements {
            XCTAssertEqual(sketch.query(element: element), 0)
        }
    }
    
    func testSimpleUsage() {
        let sketch = CountMinSketch<String>(delta: 0.01, epsilon: 0.01)
        let expectedCount: UInt64 = 1000
        for _ in 0..<expectedCount {
            sketch.add(element: "a")
        }
        
        XCTAssertEqual(sketch.query(element: "a"), expectedCount)
        XCTAssertEqual(sketch.query(element: "b"), 0)
        XCTAssertEqual(sketch.count, expectedCount)
    }
    
    func testIncreas() {
        let sketch = CountMinSketch<String>(delta: 0.01, epsilon: 0.01)
        sketch.add(element: "a", value: 10)
        XCTAssertEqual(sketch.query(element: "a"), 10)
        
        sketch.add(element: "a", value: 20)
        XCTAssertEqual(sketch.query(element: "a"), 30)
    }
}
