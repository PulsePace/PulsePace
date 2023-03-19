//
//  SlideGameHO.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation
import simd

// Straight slider
class SlideGameHO: GameHO {
    typealias Vector2 = SIMD2<Double>
    typealias CommandType = SlideCommandHO
    let wrappingObject: Entity

    let lifeStart: Double
    let optimalStart: Double
    let optimalLife: Double
    let lifeTime: Double
    // lifestage is clamped between 0 and 1, 0.5 being the optimal
    var lifeStage = LifeStage.startStage
    var onLifeEnd: [(SlideGameHO) -> Void] = []

    let startPosition: CGPoint
    var expectedPosition: CGPoint
    let endPosition: CGPoint

    let maxPositionError: Double = 20
    var minimumProximity: Double = 30
    var proximityScore: Double = 0
    var proximityScoreThresholds: [Double] = [0.2, 1, 1]
    var lastCheckedSongPosition: Double?
    var isHit = false

    var command: SlideCommandHO

    init(slideHO: SlideHitObject, wrappingObject: Entity, preSpawnInterval: Double, slideSpeed: Double) {
        self.wrappingObject = wrappingObject
        self.lifeStart = slideHO.beat - preSpawnInterval
        self.optimalStart = slideHO.beat
        let optimalLife = simd_length(
            Vector2(x: slideHO.position.x, y: slideHO.position.y)
                - Vector2(x: slideHO.endPosition.x, y: slideHO.endPosition.y)
        ) / slideSpeed
        self.optimalLife = optimalLife
        self.lifeTime = optimalLife + preSpawnInterval * 2

        self.startPosition = slideHO.position
        self.endPosition = slideHO.endPosition
        self.expectedPosition = slideHO.position

        self.command = SlideCommandHO()
    }

    func updateState(currBeat: Double) {
        expectedPosition = Lerper.linearVector2(
            from: startPosition,
            to: endPosition,
            t: (currBeat - optimalStart) / optimalLife
        )

        lifeStage = LifeStage(Lerper.linearFloat(from: 0, to: 1, t: abs(currBeat - lifeStart) / lifeTime))
        if currBeat - lifeStart >= lifeTime {
            destroyObject()
        }
    }

    func checkOnInput(input: GameInputData, scoreManager: ScoreManager) {
        guard let lastCheckedSongPosition = lastCheckedSongPosition else {
            lastCheckedSongPosition = input.songPositionReceived
            return
        }
        guard input.songPositionReceived != lastCheckedSongPosition else {
            return
        }

        let locationError = simd_length(SIMD2(
            x: input.location.x - self.expectedPosition.x,
            y: input.location.y - self.expectedPosition.y
        ))

        // if drag too far away
        if locationError > maxPositionError {
            scoreManager.missCount += 1
            destroyObject()
            return
        }

        let clampedLocationError = Math.clamp(num: locationError,
                                              minimum: 0,
                                              maximum: minimumProximity) / minimumProximity
        let deltaTime = input.songPositionReceived - lastCheckedSongPosition
        proximityScore += (1 - clampedLocationError) * deltaTime / optimalLife
        self.lastCheckedSongPosition = input.songPositionReceived
    }

    func checkOnInputEnd(input: GameInputData, scoreManager: ScoreManager) {
        // if drag ended too early
        let locationError = simd_length(SIMD2(
            x: input.location.x - self.endPosition.x,
            y: input.location.y - self.endPosition.y
        ))
        if locationError > maxPositionError {
            scoreManager.missCount += 1
            destroyObject()
        }

        isHit = true
        // TODO: define proper scoring rule
        if proximityScore < proximityScoreThresholds[0] {
            // perfect
            scoreManager.perfetHitCount += 1
            scoreManager.score += 2
        } else {
            // good
            scoreManager.goodHitCount += 1
            scoreManager.score += 1
        }
    }
}
