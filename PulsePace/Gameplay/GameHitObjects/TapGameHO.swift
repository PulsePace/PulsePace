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
    let lifeOptimal = LifeStage(0.5)
    let lifeEnd: Double
    // lifestage is clamped between 0 and 1, 0.5 being the optimal
    var lifeStage = LifeStage.startStage
    var onLifeEnd: [(TapGameHO) -> Void] = []

    var command: TapCommandHO

    init(tapHO: TapHitObject, wrappingObject: Entity, preSpawnInterval: Double) {
        self.position = tapHO.position
        self.wrappingObject = wrappingObject
        self.lifeStart = tapHO.startTime - preSpawnInterval
        self.lifeEnd = tapHO.startTime + preSpawnInterval
        self.command = TapCommandHO()
    }

    func updateState(currBeat: Double) {
        lifeStage = LifeStage(Lerper.linearFloat(from: 0, to: 1, t: abs(currBeat - lifeStart) / lifeTime))
        if currBeat - lifeStart >= lifeTime {
            destroyObject()
        }
    }
}
