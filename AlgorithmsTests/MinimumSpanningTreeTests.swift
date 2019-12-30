//
//  MinimumSpanningTreeTests.swift
//  AlgorithmsTests
//
//  Created by Philipp Brendel on 29.12.19.
//  Copyright © 2019 Entenwolf Software. All rights reserved.
//

import XCTest
import SwiftAlgorithms

class MinimumSpanningTreeTests: XCTestCase {
    typealias G = AdjacencyListGraph<String, Int>

    func test() {
        var g = G()
        let cat = g.addNode(labelled: "cat")
        let dog = g.addNode(labelled: "dog")
        let fox = g.addNode(labelled: "fox")
        let cow = g.addNode(labelled: "cow")
        let doe = g.addNode(labelled: "doe")
        
        g.addEdge(between: cat, and: dog, labelled: 1)
        g.addEdge(between: dog, and: fox, labelled: 5)
        g.addEdge(between: cat, and: fox, labelled: 2)
        g.addEdge(between: cat, and: cow, labelled: 1)
        g.addEdge(between: dog, and: doe, labelled: 2)
        g.addEdge(between: fox, and: cow, labelled: 2)
        g.addEdge(between: fox, and: doe, labelled: 9)
        g.addEdge(between: cow, and: doe, labelled: 3)
        
        let tree = minimumSpanningTree(graph: g)
        
        XCTAssertEqual("cat", tree.root)
        XCTAssertEqual(["cow", "dog", "fox"], tree.children(of: "cat").sorted())
        XCTAssertEqual(["doe"], tree.children(of: "dog"))
        XCTAssertEqual([], tree.children(of: "fox"))
        XCTAssertEqual([], tree.children(of: "cow"))
        XCTAssertEqual([], tree.children(of: "doe"))
    }
    
    func testWikipedia() {
        var graph = G()
        let d = graph.addNode(labelled: "D")
        let a = graph.addNode(labelled: "A")
        let b = graph.addNode(labelled: "B")
        let c = graph.addNode(labelled: "C")
        let e = graph.addNode(labelled: "E")
        let f = graph.addNode(labelled: "F")
        let g = graph.addNode(labelled: "G")
        
        graph.addEdge(between: a, and: b, labelled: 7)
        graph.addEdge(between: a, and: d, labelled: 5)
        graph.addEdge(between: b, and: c, labelled: 8)
        graph.addEdge(between: b, and: d, labelled: 9)
        graph.addEdge(between: b, and: e, labelled: 7)
        graph.addEdge(between: c, and: e, labelled: 5)
        graph.addEdge(between: d, and: e, labelled: 15)
        graph.addEdge(between: d, and: f, labelled: 6)
        graph.addEdge(between: e, and: f, labelled: 8)
        graph.addEdge(between: e, and: g, labelled: 9)
        graph.addEdge(between: f, and: g, labelled: 11)
        
        let tree = minimumSpanningTree(graph: graph)
        
        XCTAssertEqual("D", tree.root)
        XCTAssertEqual(["A", "F"], tree.children(of: "D").sorted())
        XCTAssertEqual(["B"], tree.children(of: "A").sorted())
        XCTAssertEqual(["E"], tree.children(of: "B").sorted())
        XCTAssertEqual(["C", "G"], tree.children(of: "E").sorted())
        XCTAssertEqual([], tree.children(of: "F"))
        XCTAssertEqual([], tree.children(of: "G"))
        XCTAssertEqual([], tree.children(of: "C"))
    }
}
