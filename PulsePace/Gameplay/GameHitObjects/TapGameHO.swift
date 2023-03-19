//
//  TapGameHO.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

class TapGameHO: GameHO {
    typealias CommandType = TapCommandHO

    let wrappingObject: Entity

    let position: CGPoint
    let lifeStart: Double
    let lifeOptimal: Double
    let lifeTime: Double
    // lifestage is clamped between 0 and 1, 0.5 being the optimal
    var lifeStage = LifeStage.startStage
    var onLifeEnd: [(TapGameHO) -> Void] = []

    var isHit = false
    var proximityScore: Double = 0
    var proximityScoreThresholds: [Double] = [0.2, 1, 1]

    var command: TapCommandHO

    init(tapHO: TapHitObject, wrappingObject: Entity, preSpawnInterval: Double) {
        self.position = tapHO.position
        self.wrappingObject = wrappingObject
        self.lifeStart = tapHO.beat - preSpawnInterval
        self.lifeOptimal = tapHO.beat
        self.lifeTime = preSpawnInterval * 2
        self.command = TapCommandHO()
    }

    func updateState(currBeat: Double) {
        lifeStage = LifeStage(Lerper.linearFloat(from: 0, to: 1, t: abs(currBeat - lifeStart) / lifeTime))
        if currBeat - lifeStart >= lifeTime {
            destroyObject()
        }
    }

    func checkOnInput(input: GameInputData, scoreManager: ScoreManager) {
        checkOnInputEnd(input: input, scoreManager: scoreManager)
    }

    func checkOnInputEnd(input: GameInputData, scoreManager: ScoreManager) {
        if isHit {
            return
        }

        isHit = true
        proximityScore += abs(input.songPositionReceived - lifeOptimal) / lifeTime

        // TODO: refine scoring rule
        if proximityScore < proximityScoreThresholds[0] {
            // perfect
            scoreManager.perfetHitCount += 1
            scoreManager.score += 2
        } else {
            // good
            scoreManager.goodHitCount += 1
            scoreManager.score += 1
        }
        self.destroyObject()
    }
}
