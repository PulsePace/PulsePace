//
//  LerperTests.swift
//  PulsePaceTests
//
//  Created by James Chiu on 19/3/23.
//

import XCTest
@testable import PulsePace

class LerperTests: XCTestCase {

    func testLinearFloat() {
        XCTAssertEqual(Lerper.linearFloat(from: 0, to: 10, t: 0), 0)
        XCTAssertEqual(Lerper.linearFloat(from: 0, to: 10, t: 1), 10)
        XCTAssertEqual(Lerper.linearFloat(from: 0, to: 10, t: 0.5), 5)
        XCTAssertEqual(Lerper.linearFloat(from: -5, to: 5, t: 0.25), -2.5)
        XCTAssertEqual(Lerper.linearFloat(from: -5, to: 5, t: 1.5), 5)
    }

    func testCubicFloat() {
        XCTAssertEqual(Lerper.cubicFloat(from: 0, to: 10, t: 0), 0)
        XCTAssertEqual(Lerper.cubicFloat(from: 0, to: 10, t: 1), 10)
        XCTAssertEqual(Lerper.cubicFloat(from: 0, to: 10, t: 0.5), 8.75)
        XCTAssertEqual(Lerper.cubicFloat(from: -5, to: 5, t: 0.25), 0.78125)
        XCTAssertEqual(Lerper.cubicFloat(from: -5, to: 5, t: 1.5), 5)
    }

    func testLinearVector2() {
        XCTAssertEqual(Lerper.linearVector2(
            from: CGPoint(x: 0, y: 0),
            to: CGPoint(x: 10, y: 10),
            t: 0
        ), CGPoint(x: 0, y: 0))
        XCTAssertEqual(Lerper.linearVector2(
            from: CGPoint(x: 0, y: 0),
            to: CGPoint(x: 10, y: 10),
            t: 1
        ), CGPoint(x: 10, y: 10))
        XCTAssertEqual(Lerper.linearVector2(
            from: CGPoint(x: 0, y: 0),
            to: CGPoint(x: 10, y: 10),
            t: 0.5
        ), CGPoint(x: 5, y: 5))
        XCTAssertEqual(Lerper.linearVector2(
            from: CGPoint(x: -5, y: -5),
            to: CGPoint(x: 5, y: 5),
            t: 0.25
        ), CGPoint(x: -2.5, y: -2.5))
        XCTAssertEqual(Lerper.linearVector2(
            from: CGPoint(x: -5, y: -5),
            to: CGPoint(x: 5, y: 5),
            t: 1.5
        ), CGPoint(x: 5, y: 5))
    }
}
