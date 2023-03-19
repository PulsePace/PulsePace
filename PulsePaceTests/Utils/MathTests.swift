//
//  MathTests.swift
//  PulsePaceTests
//
//  Created by James Chiu on 19/3/23.
//

import XCTest
@testable import PulsePace

final class MathTests: XCTestCase {

    func testDeg2Rad() {
        XCTAssertEqual(Math.deg2Rad(0), 0)
        XCTAssertEqual(Math.deg2Rad(90), CGFloat.pi / 2)
        XCTAssertEqual(Math.deg2Rad(180), CGFloat.pi)
        XCTAssertEqual(Math.deg2Rad(270), 3 * CGFloat.pi / 2)
        XCTAssertEqual(Math.deg2Rad(360), 2 * CGFloat.pi)
    }

    func testRad2Deg() {
        XCTAssertEqual(Math.rad2Deg(0), 0)
        XCTAssertEqual(Math.rad2Deg(CGFloat.pi / 2), 90)
        XCTAssertEqual(Math.rad2Deg(CGFloat.pi), 180)
        XCTAssertEqual(Math.rad2Deg(3 * CGFloat.pi / 2), 270)
        XCTAssertEqual(Math.rad2Deg(2 * CGFloat.pi), 360)
    }

    func testSign() {
        XCTAssertEqual(Math.sign(0), 0)
        XCTAssertEqual(Math.sign(-1), -1)
        XCTAssertEqual(Math.sign(1), 1)
        XCTAssertEqual(Math.sign(-100), -1)
        XCTAssertEqual(Math.sign(100), 1)
    }

    func testClamp() {
        XCTAssertEqual(Math.clamp(num: 0, minimum: -1, maximum: 1), 0)
        XCTAssertEqual(Math.clamp(num: -5, minimum: -1, maximum: 1), -1)
        XCTAssertEqual(Math.clamp(num: 5, minimum: -1, maximum: 1), 1)
        XCTAssertEqual(Math.clamp(num: 0.5, minimum: -1, maximum: 1), 0.5)
        XCTAssertEqual(Math.clamp(num: -0.5, minimum: -1, maximum: 1), -0.5)
    }
}
