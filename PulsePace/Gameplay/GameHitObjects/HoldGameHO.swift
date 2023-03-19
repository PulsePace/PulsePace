//
//  HoldGameHO.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

class HoldGameHO: GameHO {
    typealias CommandType = HoldCommandHO

    let wrappingObject: Entity
    let position: CGPoint

    let lifeStart: Double
    let optimalStart: Double
    let optimalStageStart: LifeStage
    let optimalEnd: Double
    let optimalStageEnd: LifeStage
    let optimalLife: Double
    let lifeEnd: Double

    // lifestage is clamped between 0 and 1, 0.5 being the optimal
    var lifeStage = LifeStage.startStage
    var onLifeEnd: [(HoldGameHO) -> Void] = []

    var proximityScore: Double = 0
    var minimumProximity: Double = 30
    var proximityScoreThresholds: [Double] = [0.2, 0.5, 1]
    var lastCheckedSongPosition: Double?
    var isHit = false

    var command: HoldCommandHO

    init(holdHO: HoldHitObject, wrappingObject: Entity, preSpawnInterval: Double) {
        self.position = holdHO.position
        self.wrappingObject = wrappingObject
        self.lifeStart = holdHO.startTime - preSpawnInterval
        self.optimalStart = holdHO.startTime

        let normSpawnInterval = Lerper.linearFloat(
            from: 0,
            to: 1,
            t: preSpawnInterval / (holdHO.duration + preSpawnInterval * 2)
        )
        self.optimalStageStart = LifeStage(normSpawnInterval)
        self.optimalEnd = holdHO.endTime
        self.optimalStageEnd = LifeStage(1 - normSpawnInterval)
        self.optimalLife = holdHO.endTime - holdHO.startTime
        self.lifeEnd = holdHO.endTime + preSpawnInterval
        self.command = HoldCommandHO()
    }

    func updateState(currBeat: Double) {
        lifeStage = LifeStage(Lerper.linearFloat(from: 0, to: 1, t: abs(currBeat - lifeStart) / lifeTime))
        if currBeat - lifeStart >= lifeTime {
            destroyObject()
        }
    }

    func checkOnInput(input: GameInputData, scoreManager: ScoreManager) {
        guard let lastCheckedSongPosition = lastCheckedSongPosition else {
            proximityScore += abs(input.songPositionReceived - lifeStart) / optimalLife
            lastCheckedSongPosition = input.songPositionReceived
            return
        }
        guard input.songPositionReceived != lastCheckedSongPosition else {
            return
        }
        self.lastCheckedSongPosition = input.songPositionReceived
    }

    func checkOnInputEnd(input: GameInputData, scoreManager: ScoreManager) {
        proximityScore += abs(input.songPositionReceived - lifeStart) / optimalLife

        // TODO: define proper scoring rule
        if proximityScore < proximityScoreThresholds[0] {
            // perfect
            scoreManager.perfetHitCount += 1
            scoreManager.score += 2
        } else if proximityScore < proximityScoreThresholds[1] {
            // good
            scoreManager.goodHitCount += 1
            scoreManager.score += 1
        } else {
            // miss
            scoreManager.missCount += 1
            destroyObject()
        }
    }
}
