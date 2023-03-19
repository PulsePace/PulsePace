//
//  ConductorTest.swift
//  PulsePaceTests
//
//  Created by James Chiu on 19/3/23.
//

import XCTest
@testable import PulsePace

final class ConductorTests: XCTestCase {

    func testStepUpdatesSongPosition() {
        let bpm = 120.0
        let conductor = Conductor(bpm: bpm, playbackScale: 1.0)

        XCTAssertEqual(conductor.songPosition, 0.0)

        let deltaTime = 1.0
        conductor.step(deltaTime)

        XCTAssertEqual(conductor.songPosition, bpm / 60.0 * deltaTime)

        // Step again
        conductor.step(deltaTime)
        XCTAssertEqual(conductor.songPosition, bpm / 60.0 * deltaTime * 2)
    }
}
