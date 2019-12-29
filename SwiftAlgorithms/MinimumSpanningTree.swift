//
//  MinimumSpanningTree.swift
//  SwiftAlgorithms
//
//  Created by Philipp Brendel on 29.12.19.
//  Copyright © 2019 Entenwolf Software. All rights reserved.
//

import Foundation

public func minimumSpanningTree<G:UndirectedGraph>(graph: G)
    where G.Node: Hashable,
        G.EdgeLabel: Comparable,
        G.EdgeLabel == Int {
    func createNodeQueue(startNode: G.Node) -> PriorityQueue<G.Node, Int> {
        let q = PriorityQueue<G.Node, Int>()
        
        q.insert(startNode, key: 0)
        
        for n in graph.nodes {
            if n != startNode {
                q.insert(n, key: Int.max)
            }
        }
        
        return q
    }
    
    guard let startNode = graph.nodes.first else { fatalError() }

    let q = createNodeQueue(startNode: startNode)
    var parent: [G.Node:G.Node] = [:]
    
    while !q.isEmpty {
        let u = q.extractMin()!
        
        for v in graph.neighbors(of: u) {
            let w = graph.label(from: u, to: v)!
            
            if let (_, key) = q.lookup(element: v),
                w < key {
                parent[v] = u
                q.decreaseKey(v, newKey: w)
            }
        }
    }
}
