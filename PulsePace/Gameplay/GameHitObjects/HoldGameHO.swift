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

    let lifeStart: Double
    let lifeOptimal: Double
    let lifeTime: Double
    // lifestage is clamped between 0 and 1, 0.5 being the optimal
    var lifeStage = LifeStage.startStage
    var onLifeEnd: [(HoldGameHO) -> Void] = []

    var command: HoldCommandHO

    init(holdHO: HoldHitObject, wrappingObject: Entity, preSpawnInterval: Double) {
        self.wrappingObject = wrappingObject
        self.lifeStart = holdHO.beat - preSpawnInterval
        self.lifeOptimal = holdHO.duration
        self.lifeTime = preSpawnInterval * 2 + holdHO.duration
        self.command = HoldCommandHO()
    }

    func updateState(currBeat: Double) {
        lifeStage = LifeStage(Lerper.linearFloat(from: 0, to: 1, t: abs(currBeat - lifeStart) / lifeTime))
        if currBeat - lifeStart >= lifeTime {
            destroyObject()
        }
    }
}
