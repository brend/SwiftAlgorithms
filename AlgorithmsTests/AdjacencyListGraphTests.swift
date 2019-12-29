//
//  AdjacencyListGraphTests.swift
//  AdjacencyListGraphTests
//
//  Created by Philipp Brendel on 29.12.19.
//  Copyright © 2019 Entenwolf Software. All rights reserved.
//

import XCTest
import SwiftAlgorithms

class AdjacencyListGraphTests: XCTestCase {

    typealias G = AdjacencyListGraph<String, Int>
    
    var graph: G!
    
    override func setUp() {
        graph = G()
    }

    override func tearDown() {
        graph = nil
    }

    func testAddNode() {
        let node = graph.addNode(labelled: "cat")
        
        XCTAssertEqual([node], graph.nodes)
    }
    
    func testRemoveNode() {
        let node = graph.addNode(labelled: "cat")
        
        graph.removeNode(node)
        
        XCTAssertEqual([], graph.nodes)
    }
    
    func testAddEdge() {
        let catNode = graph.addNode(labelled: "cat")
        let dogNode = graph.addNode(labelled: "dog")
        let foxNode = graph.addNode(labelled: "fox")
        
        graph.addEdge(between: catNode, and: dogNode, labelled: 3)
        graph.addEdge(between: dogNode, and: foxNode, labelled: 2)
        
        XCTAssertTrue(graph.adjacent(catNode, dogNode))
        XCTAssertTrue(graph.adjacent(foxNode, dogNode))
        XCTAssertFalse(graph.adjacent(catNode, foxNode))
    }
    
    func testRemoveEdge() {
        let catNode = graph.addNode(labelled: "cat")
        let dogNode = graph.addNode(labelled: "dog")
        let foxNode = graph.addNode(labelled: "fox")
        
        graph.addEdge(between: catNode, and: dogNode, labelled: 3)
        graph.addEdge(between: dogNode, and: foxNode, labelled: 2)
        
        graph.removeEdge(between: dogNode, and: catNode)
        
        XCTAssertFalse(graph.adjacent(catNode, dogNode))
        XCTAssertTrue(graph.adjacent(foxNode, dogNode))
    }
    
    func testRemoveNodeRemovesEdges() {
        let catNode = graph.addNode(labelled: "cat")
        let dogNode = graph.addNode(labelled: "dog")
        let foxNode = graph.addNode(labelled: "fox")
        
        graph.addEdge(between: catNode, and: dogNode, labelled: 3)
        graph.addEdge(between: dogNode, and: foxNode, labelled: 2)
        
        graph.removeNode(catNode)
        
        XCTAssertFalse(graph.nodes.contains(catNode))
        XCTAssertFalse(graph.adjacent(catNode, dogNode))
        XCTAssertTrue(graph.adjacent(foxNode, dogNode))
    }
    
    func testImmutability() {
        let catNode = graph.addNode(labelled: "cat")
        let dogNode = graph.addNode(labelled: "dog")
        let foxNode = graph.addNode(labelled: "fox")
        
        graph.addEdge(between: catNode, and: dogNode, labelled: 3)
        
        let copy = graph!
        
        graph.addEdge(between: dogNode, and: foxNode, labelled: 2)
        
        XCTAssertTrue(graph.adjacent(catNode, dogNode))
        XCTAssertTrue(graph.adjacent(foxNode, dogNode))
        XCTAssertFalse(graph.adjacent(catNode, foxNode))
        
        XCTAssertTrue(copy.adjacent(catNode, dogNode))
        XCTAssertFalse(copy.adjacent(foxNode, dogNode))
        XCTAssertFalse(copy.adjacent(catNode, foxNode))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
