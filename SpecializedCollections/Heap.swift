//
//  Heap.swift
//  SpecializedCollections
//
//  Created by Philipp Brendel on 25.12.19.
//  Copyright © 2019 Entenwolf Software. All rights reserved.
//

import Foundation

/* Implementation of a binary heap data structure.
 * Closely follows the outline given in https://de.wikipedia.org/wiki/Binärer_Heap
 */
public class Heap<Element, Key> where Key: Comparable {
    public init() {
    }
    
    typealias LiftedKey = InfinityLift<Key>

    private struct KeyedElement {
        let key: LiftedKey
        let element: Element
    }
    
    private var elements: [KeyedElement] = []
    
    private func left(_ i: Int) -> Int {
        2 * i + 1
    }

    private func right(_ i: Int) -> Int {
        2 * i + 2
    }

    private func parent(_ i: Int) -> Int {
        (i - 1) / 2
    }
    
    public var count: Int { elements.count }
    
    public var isEmpty: Bool { elements.isEmpty }

    private func isheap(_ i: Int) -> Bool {
        let left = self.left(i)
        let right = self.right(i)
        
        let leftOK = !(left < count) || key(i) <= key(left)
        let rightOK = !(right < count) || key(i) <= key(right)
        let leftIsHeap = !(left < count) || isheap(left)
        let rightIsHeap = !(right < count) || isheap(right)
        
        return leftOK && rightOK && leftIsHeap && rightIsHeap
    }
    
    private func key(_ i: Int) -> LiftedKey {
        elements[i].key
    }
    
    private func swapAt(_ i: Int, _ j: Int) {
        elements.swapAt(i, j)
    }

    private func heapify(_ a: Int) {
        var i = a
        
        repeat {
            let left = self.left(i)
            let right = self.right(i)

            //assert(isheap(left) && isheap(right))
            
            var min = i

            if left < count && key(left) < key(min) {
                min = left
            }
            
            if right < count && key(right) < key(min) {
                min = right
            }
            
            if min == i {
                break
            }
            
            swapAt(i, min)
            i = min
        } while true
    }
    
    public func decreaseKey(
        _ i: Int,
        _ newElement: Element,
        _ newKey: Key) {
        
        //assert(isheap(0))
        assert(key(i) >= .some(newKey))
            
        elements[i] = KeyedElement(key: .some(newKey), element: newElement)
        
        var i = i
        
        while i > 0 && key(i) < key(parent(i)) {
            swapAt(i, parent(i))
            i = parent(i)
        }
    }
    
    public func insert(_ newElement: Element, key newKey: Key) {
        //assert(isheap(0))
        
        elements.append(KeyedElement(key: .positiveInfinity, element: newElement))
        
        decreaseKey(elements.count - 1, newElement, newKey)
    }
    
    public func printDebug() {
        print("[\(elements.map {"\($0.key)"}.joined(separator: ", "))]")
    }
    
    public func extractMin() -> Element? {
        //assert(isheap(0))
        
        guard count > 0 else { return nil }
        
        return remove(0)
    }
    
    private func remove(_ i: Int) -> Element? {
        //assert(isheap(0))
        assert(i < count)
        
        let removedItem = elements[i]
        let lastIdx = count - 1
        
        swapAt(i, lastIdx)
        elements.removeLast()
        
        if i != lastIdx {
            if i == 0 || key(i) > key(parent(i)) {
                heapify(i)
            } else {
                fatalError("what condition does this case represent?")
            }
        }
        
        return removedItem.element
    }
    
    /* firstIndex(where:) exists only to reduce the number of times
     * the array has to be queried to find a specific element */
    public func firstIndex(where predicate: (Element, Key) -> Bool) -> Int? {
        elements.firstIndex {
            keyedElement in
            
            let key = keyedElement.key.unlifted
            
            return predicate(keyedElement.element, key)
        }
    }
}

extension Heap where Element: Equatable {
    func lookup(element: Element) -> (Element, Key)? {
        guard let foundElement = elements.first(where: { $0.element == element })
            else { return nil }
        
        return (element, foundElement.key.unlifted)
    }
    
    func decreaseKey(_ element: Element, newKey: Key) {
        guard let i = elements.firstIndex(where: { $0.element == element })
            else { return }
        
        decreaseKey(i, element, newKey)
    }
    
    func firstIndex(of element: Element) -> Int? {
        elements.firstIndex { $0.element == element }
    }
}
