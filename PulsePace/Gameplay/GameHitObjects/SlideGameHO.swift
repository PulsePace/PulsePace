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

    var command: SlideCommandHO

    init(slideHO: SlideHitObject, wrappingObject: Entity, preSpawnInterval: Double, slideSpeed: Double) {
        self.wrappingObject = wrappingObject
        self.lifeStart = slideHO.startTime - preSpawnInterval
        self.optimalStart = slideHO.startTime
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
}
