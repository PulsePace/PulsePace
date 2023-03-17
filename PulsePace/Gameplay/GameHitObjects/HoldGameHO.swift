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
    var isHit = false

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

    func checkOnInput(input: InputData, scoreManager: ScoreManager) {

    }

    func checkOnInputEnd(input: InputData, scoreManager: ScoreManager) {
        // TODO: Possible ways to determine hit status:
        // 1) if input end before lifeStage completes, should be an immediate miss.
            // 1.1) if the time holding already passes some threshold, could be a good or perfect as well.
        // 2) allow user to lift finger in the middle then contine pressing,
        // determine perfect, good, miss solely based on the total time holding
    }
}
