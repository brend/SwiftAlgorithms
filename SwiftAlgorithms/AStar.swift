//
//  AStar.swift
//  SwiftAlgorithms
//
//  Created by Philipp Brendel on 25.12.19.
//  Copyright © 2019 Entenwolf Software. All rights reserved.
//

import Foundation

public protocol AStarNode {
    func getPredecessor() -> Self?
    func setPredecessor(_ predecessor: Self?)
    func successors() -> [Self]
    func cost(to successor: Self) -> Float
    func h() -> Float
}

public class AStar<Node: AnyObject> where Node: AStarNode & Hashable & Equatable {
    
    typealias OpenList = PriorityQueue<Node, Float>
    
    class ClosedList<Element> where Element: Hashable {
        var elements: [Element: Element] = [:]
        
        func add(_ element: Element) {
            elements[element] = element
        }
        
        func contains(_ element: Element) -> Bool {
            elements[element] != nil
        }
    }

    public init() {
    }
    
    func constructPath(_ goal: Node) -> [Node] {
        var path: [Node] = []
        var currentNode: Node? = goal
        
        repeat {
            path.append(currentNode!)
            
            currentNode = currentNode!.getPredecessor()
        } while currentNode != nil
        
        return path.reversed()
    }

    func expandNode(
        _ currentNode: Node,
        _ closedList: ClosedList<Node>,
        _ openListDictionary: inout [Node: Node],
        _ openList: OpenList,
        _ g: inout [Node:Float]) {
        for successor in currentNode.successors() {
            if closedList.contains(successor) {
                continue
            }
            
            let tentativeG = g[currentNode]! + currentNode.cost(to: successor)
            // let successorIndexInOpenList = openList.firstIndex { (elem, _) in elem == successor}
            // let successorIndexInOpenList = openList.firstIndex(of: successor)
            
            //let successorIsInOpenList = successorIndexInOpenList != nil //openList.contains(successor)
            let successorIsInOpenList = openListDictionary[successor] != nil
            
            if successorIsInOpenList && g[successor]! <= tentativeG {
                continue
            }
            
            successor.setPredecessor(currentNode)
            
            g[successor] = tentativeG
            
            let f = tentativeG + successor.h()
            
            if successorIsInOpenList,
                let successorIndex = openList.firstIndex(of: successor) {
                openList.decreaseKey(successorIndex, successor, f)
            } else {
                openList.insert(successor, key: f)
                openListDictionary[successor] = successor
            }
        }
    }

    public func searchPath(from start: Node, to goal: Node) -> [Node] {
        let openList = OpenList()
        let closedList = ClosedList<Node>()
        var g: [Node: Float] = [:]
        
        var openListDictionary: [Node: Node] = [:]
        
        openList.insert(start, key: 0)
        
        g[start] = 0
        
        repeat {
            let currentNode = openList.extractMin()!
                        
            if currentNode == goal {
                return constructPath(currentNode)
            }
            
            openListDictionary.removeValue(forKey: currentNode)
            closedList.add(currentNode)
            
            expandNode(currentNode, closedList, &openListDictionary, openList, &g)
        } while !openList.isEmpty
        
        return []
    }
}

