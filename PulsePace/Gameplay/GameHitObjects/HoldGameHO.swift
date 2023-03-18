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
}
