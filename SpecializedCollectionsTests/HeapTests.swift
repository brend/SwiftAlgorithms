//
//  HeapTests.swift
//  HeapTests
//
//  Created by Philipp Brendel on 25.12.19.
//  Copyright © 2019 Entenwolf Software. All rights reserved.
//

import XCTest
import SpecializedCollections

class HeapTests: XCTestCase {
    
    var heap: Heap<String, Int>!
    
    override func setUp() {
        heap = Heap<String, Int>()
    }

    override func tearDown() {
        heap = nil
    }
    
    func testCount() {
        XCTAssertEqual(0, heap.count)
        
        heap.insert("fox", key: 17)
        heap.insert("cat", key: 4)
        heap.insert("dog", key :5)
            
        XCTAssertEqual(3, heap.count)
        
        XCTAssertNotNil(heap.extractMin())
        
        XCTAssertEqual(2, heap.count)
        
        XCTAssertNotNil(heap.extractMin())
        
        XCTAssertEqual(1, heap.count)
        
        XCTAssertNotNil(heap.extractMin())
        
        XCTAssertEqual(0, heap.count)
        
        XCTAssertNil(heap.extractMin())
        
        XCTAssertEqual(0, heap.count)
    }
    
    func testIsEmpty() {
        XCTAssertTrue(heap.isEmpty)
        
        heap.insert("fox", key: 17)
        heap.insert("cat", key: 4)
        heap.insert("dog", key :5)
            
        XCTAssertFalse(heap.isEmpty)
        
        XCTAssertNotNil(heap.extractMin())
        
        XCTAssertFalse(heap.isEmpty)
        
        XCTAssertNotNil(heap.extractMin())
        
        XCTAssertFalse(heap.isEmpty)
        
        XCTAssertNotNil(heap.extractMin())
        
        XCTAssertTrue(heap.isEmpty)
        
        XCTAssertNil(heap.extractMin())
        
        XCTAssertTrue(heap.isEmpty)
    }
    
    func testExtractMin() {
        XCTAssertTrue(heap.isEmpty)
        
        heap.insert("fox", key: 17)
        heap.insert("cat", key: 4)
        heap.insert("dog", key :5)
            
        XCTAssertEqual("cat", heap.extractMin())
        XCTAssertEqual("dog", heap.extractMin())
        XCTAssertEqual("fox", heap.extractMin())
        XCTAssertEqual(nil, heap.extractMin())
    }

    func testExample() {
        let keysAndValues =
        [
            4: "dog",
            1: "cat",
            9: "mouse",
            5: "fox",
            8: "bear",
            6: "platypus",
            2: "tiger",
            3: "elephant",
            7: "hippopotamus"
        ]
        let heap = Heap<String, Int>()
        
        for (key, value) in keysAndValues {
            heap.insert(value, key: key)
        }

        var orderedValues: [String] = []
        
        while !heap.isEmpty {
            orderedValues.append(heap.extractMin()!)
        }
        
        XCTAssertEqual(orderedValues, [
            "cat",
            "tiger",
            "elephant",
            "dog",
            "fox",
            "platypus",
            "hippopotamus",
            "bear",
            "mouse"
        ])
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
