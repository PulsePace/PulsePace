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
    var minimumProximity: Double = 30
    var proximityScore: Double = 0

    var command: SlideCommandHO
    var isHit = false

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

    func checkOnInput(input: InputData, scoreManager: ScoreManager) {
        // TODO: define how slider hit is determined.
        // 1) hit count is proportional to slider length.
        // Eg, 3 beat long slider, if user hit the first two, it will be 2 hit and one miss
        // may not be possible since it seems fractional beats are allowed
        // 2) whole slider is one hit or miss.
            // 2.1) if user finger digress too far, it will be an immediate miss.
            // Accumulate proximityScore then at the end of the slider life, determine perfect or good.
            // 2.2) Accumulate proximityScore then at the end of the slider life, determine perfect, good, or miss.
//        let locationError = simd_length(SIMD2(
//            x: input.location.x - self.expectedPosition.x,
//            y: input.location.y - self.expectedPosition.y
//        ))
//        let clampedLocationError = Math.clamp(num: locationError,
//                                              minimum: 0,
//                                              maximum: minimumProximity) / minimumProximity
//        proximityScore += clampedLocationError
    }

    func checkOnInputEnd(input: InputData, scoreManager: ScoreManager) {

        // TODO: define proper checking rule and scoring rule
//        if (proximityScore < 0.5) {
//            // perfect
//            scoreManager.perfetHitCount += 1
//            scoreManager.score += 2
//        } else {
//            // good
//            scoreManager.goodHitCount += 1
//            scoreManager.score += 1
//        }
    }
}
