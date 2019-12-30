//
//  Graph.swift
//  SwiftAlgorithms
//
//  Created by Philipp Brendel on 29.12.19.
//  Copyright © 2019 Entenwolf Software. All rights reserved.
//

import Foundation

public protocol UndirectedGraph {
    associatedtype Node
    associatedtype NodeLabel
    associatedtype EdgeLabel
    
    var nodes: [Node] { get }
    
    func adjacent(_ n: Node, _ m: Node) -> Bool
    func neighbors(of n: Node) -> [Node]
    func label(of n: Node) -> NodeLabel
    func label(from n: Node, to m: Node) -> EdgeLabel?
    
    mutating func addNode(labelled label: NodeLabel) -> Node
    mutating func removeNode(_ n: Node)
    mutating func addEdge(between n: Node, and m: Node, labelled label: EdgeLabel)
    mutating func removeEdge(between n: Node, and m: Node)
    mutating func removeAllEdges()
}

public struct AdjacencyListGraph<NodeLabel, EdgeLabel>: UndirectedGraph where NodeLabel: Equatable & Hashable {
    class Edge {
        let node1: Node
        let node2: Node
        let label: EdgeLabel
        
        init(node1: Node, node2: Node, label: EdgeLabel) {
            self.node1 = node1
            self.node2 = node2
            self.label = label
        }
        
        func connects(to node: Node) -> Bool {
            node == node1 || node == node2
        }
        
        func partner(of node: Node) -> Node {
            assert(node1 == node || node2 == node)
            
            return (node1 == node) ? node2 : node1
        }
    }
    
    public class Node: Equatable, Hashable {
        public static func == (lhs: Node, rhs: Node) -> Bool {
            lhs.label == rhs.label
        }
        
        public func hash(into hasher: inout Hasher) {
            label.hash(into: &hasher)
        }
        
        var label: NodeLabel
        var edges: [Edge]
        
        init(label: NodeLabel) {
            self.label = label
            self.edges = []
        }
        
        func adjacent(to node: Node) -> Bool {
            edge(to: node) != nil
        }
        
        func edge(to node: Node) -> Edge? {
            edges.first {$0.connects(to: node)}
        }
        
        func label(to node: Node) -> EdgeLabel? {
            edge(to: node)?.label
        }
        
        var neighbors: [Node] { edges.map {$0.partner(of: self)} }
        
        func connect(to node: Node, label: EdgeLabel) {
            guard !adjacent(to: node) else { return }
            
            edges.append(Edge(node1: self, node2: node, label: label))
        }
        
        func removeConnection(to node: Node) {
            edges.removeAll { $0.connects(to: node) }
        }
        
        func removeAllConnections() {
            edges.removeAll()
        }
    }
    
    public init() { }
    
    public var nodes: [Node] = []
    
    public func adjacent(_ n: Node, _ m: Node) -> Bool {
        n.adjacent(to: m)
    }
    
    public func neighbors(of n: Node) -> [Node] {
        n.neighbors
    }

    public func label(of node: Node) -> NodeLabel {
        node.label
    }
    
    public func label(from n: Node, to m: Node) -> EdgeLabel? {
        assert(n.adjacent(to: m))
        
        return n.label(to: m)
    }
    
    func nodeExists(labelled label: NodeLabel) -> Bool {
        nodes.first {$0.label == label} != nil
    }
    
    public mutating func addNode(labelled label: NodeLabel) -> Node {
        assert(!nodeExists(labelled: label))
        
        let node = Node(label: label)
        
        nodes.append(node)
        
        return node
    }
    
    public mutating func removeNode(_ n: Node) {
        if let index = nodes.firstIndex(of: n) {
            for m in nodes {
                m.removeConnection(to: n)
            }
            
            nodes.remove(at: index)
        }
    }
    
    public mutating func addEdge(between n: Node, and m: Node, labelled label: EdgeLabel) {
        n.connect(to: m, label: label)
        m.connect(to: n, label: label)
    }
    
    public mutating func removeEdge(between n: Node, and m: Node) {
        n.removeConnection(to: m)
        m.removeConnection(to: n)
    }
    
    public mutating func removeAllEdges() {
        for n in nodes {
            n.removeAllConnections()
        }
    }
}

extension UndirectedGraph where Node: Hashable {
    func traverseBreadthFirst(startNode: Node? = nil, apply action: (Node, Node) -> Void) {
        guard let startNode = startNode ?? nodes.first else { return }
        
        var visited: [Node: Node] = [:]
        var fringe = [startNode]
        
        repeat {
            let n = fringe.removeFirst()
            
            visited[n] = n
            
            for m in neighbors(of: n).filter({visited[$0] == nil}) {
                action(n, m)
                fringe.append(m)
            }
        } while !fringe.isEmpty
    }
}
