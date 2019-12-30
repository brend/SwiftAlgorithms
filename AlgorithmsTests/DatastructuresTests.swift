//
//  DatastructuresTests.swift
//  AlgorithmsTests
//
//  Created by Philipp Brendel on 30.12.19.
//  Copyright © 2019 Entenwolf Software. All rights reserved.
//

import Foundation

import XCTest
import SwiftAlgorithms

class DataStructuresTests: XCTestCase {
    typealias LiftedFloat = InfinityLift<Float>
    
    func testLift() {
        let x = LiftedFloat.some(17.5)
        let y = LiftedFloat.some(17)
        let z = LiftedFloat.some(-3)
        
        XCTAssertLessThan(y, x)
        XCTAssertLessThan(z, x)
        XCTAssertLessThan(z, y)
        XCTAssertGreaterThan(x, y)
        XCTAssertGreaterThan(y, z)
        
        XCTAssertGreaterThan(z, .negativeInfinity)
        XCTAssertLessThan(z, .positiveInfinity)
    }
    
    func testLiftLimits() {
        XCTAssertGreaterThan(LiftedFloat.positiveInfinity, LiftedFloat.negativeInfinity)
        XCTAssertLessThan(LiftedFloat.negativeInfinity, LiftedFloat.positiveInfinity)
    }
}
