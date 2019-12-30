//
//  MinimumSpanningTree.swift
//  SwiftAlgorithms
//
//  Created by Philipp Brendel on 29.12.19.
//  Copyright © 2019 Entenwolf Software. All rights reserved.
//

import Foundation

public func minimumSpanningTree<G:UndirectedGraph>(graph: G) -> SimpleTree<G.NodeLabel, G.EdgeLabel>
    where G.Node: Hashable,
          G.EdgeLabel: Comparable {
            
    func createNodeQueue(startNode: G.Node) -> PriorityQueue<G.Node, InfinityLift<G.EdgeLabel>> {
        let q = PriorityQueue<G.Node, InfinityLift<G.EdgeLabel>>()
        
        q.insert(startNode, key: .negativeInfinity)
        
        for n in graph.nodes {
            if n != startNode {
                q.insert(n, key: .positiveInfinity)
            }
        }
        
        return q
    }
            
    func constructTree(startNode: G.Node, parent: [G.Node: G.Node]) -> SimpleTree<G.NodeLabel, G.EdgeLabel> {
        var tree = SimpleTree<G.NodeLabel, G.EdgeLabel>()
        
        for (child, par) in parent {
            tree.addChild(n: graph.label(of: child), to: graph.label(of: par))
        }
        
        tree.root = graph.label(of: startNode)
        
        return tree
    }
    
    guard let startNode = graph.nodes.first else { fatalError() }

    let q = createNodeQueue(startNode: startNode)
    var parent: [G.Node:G.Node] = [:]
    
    while !q.isEmpty {
        let u = q.extractMin()!
        
        for v in graph.neighbors(of: u) {
            let w = InfinityLift<G.EdgeLabel>.some(graph.label(from: u, to: v)!)
            
            if let (_, key) = q.lookup(element: v),
                w < key {
                parent[v] = u
                q.decreaseKey(v, newKey: w)
            }
        }
    }
            
    let tree = constructTree(startNode: startNode, parent: parent)
    
    return tree
}
