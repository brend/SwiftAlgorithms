//
//  Auxiliary.swift
//  SwiftAlgorithms
//
//  Created by Philipp Brendel on 30.12.19.
//  Copyright © 2019 Entenwolf Software. All rights reserved.
//

import Foundation

public enum InfinityLift<T> {
    case some(T), positiveInfinity, negativeInfinity
    
    var unlifted: T {
        switch self {
        case .some(let v): return v
        default: fatalError()
        }
    }
}

extension InfinityLift: Equatable where T: Equatable {
}

extension InfinityLift: Comparable where T: Comparable {
    public static func < (lhs: InfinityLift<T>, rhs: InfinityLift<T>) -> Bool {
        
        switch (lhs, rhs) {
        case (.negativeInfinity, _): return rhs != .negativeInfinity
        case (.positiveInfinity, _): return false
        case (.some, .negativeInfinity): return false
        case (.some, .positiveInfinity): return true
        case (.some(let lhv), .some(let rhv)): return lhv < rhv
        }
    }
}
