//
//  Tree.swift
//  SwiftAlgorithms
//
//  Created by Philipp Brendel on 30.12.19.
//  Copyright © 2019 Entenwolf Software. All rights reserved.
//

import Foundation

public protocol Tree {
    associatedtype Node
    associatedtype EdgeLabel
    
    var root: Node? { get }
    var nodes: [Node] { get }
    
    func children(of node: Node) -> [Node]
    func parent(of node: Node) -> Node?
    
    mutating func addChild(n: Node, to node: Node)
}

extension Tree where Node: Hashable & CustomStringConvertible {
    public var isEmpty: Bool { root == nil }
    
    public func levels() -> [[(node: Node, parent: Node?)]] {
        guard !isEmpty else { return [] }
        
        var currentLevel = [(root!, nil as Node?)]
        var levels: [[(Node, Node?)]] = []
        
        repeat {
            levels.append(currentLevel)
            
            currentLevel = currentLevel.flatMap {
                (parent, _) in
                
                children(of: parent).map {
                    child in (child, parent)
                }
            }
        } while !currentLevel.isEmpty
        
        return levels
    }
    
    public func adjacent(_ node1: Node, _ node2: Node) -> Bool {
        parent(of: node1) == node2 || parent(of: node2) == node1
    }
}

public struct SimpleTree<Node, EdgeLabel>: Tree where Node: Hashable & Equatable {
    public var root: Node?
    
    var parentmap: [Node: Node]
    
    public var nodes: [Node] {
        root == nil ? [] : [root!] + parentmap.values
    }
    
    public init() {
        root = nil
        parentmap = [:]
    }
    
    public func children(of node: Node) -> [Node] {
        parentmap.filter { $0.value == node }.map { $0.key }
    }
    
    public func parent(of node: Node) -> Node? {
        parentmap[node]
    }
    
    public mutating func addChild(n: Node, to parent: Node) {
        parentmap[n] = parent
    }
}

