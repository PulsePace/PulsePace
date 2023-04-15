//
//  TapGameHO.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

class TapGameHO: GameHO {
    var fromPartner = false
    let wrappingObject: Entity

    let position: CGPoint
    let lifeStart: Double
    let lifeOptimal = LifeStage(0.5)
    var lifeEnd: Double
    // lifestage is clamped between 0 and 1, 0.5 being the optimal
    var lifeStage = LifeStage.startStage
    var onLifeEnd: [(TapGameHO) -> Void] = []

    var isHit = false
    var proximityScore: Double = 0

    init(tapHO: TapHitObject, wrappingObject: Entity, preSpawnInterval: Double) {
        self.position = tapHO.position
        self.wrappingObject = wrappingObject
        self.lifeStart = tapHO.startTime - preSpawnInterval
        self.lifeEnd = tapHO.startTime + preSpawnInterval
    }

    init(wrappingObject: Entity, position: CGPoint, lifeStart: Double, lifeEnd: Double,
         onLifeEnd: [(TapGameHO) -> Void], proximityScore: Double,
         lifeStage: LifeStage = LifeStage.startStage,
         isHit: Bool = false, fromPartner: Bool = false) {
        self.fromPartner = fromPartner
        self.wrappingObject = wrappingObject
        self.position = position
        self.lifeStart = lifeStart
        self.lifeEnd = lifeEnd
        self.lifeStage = lifeStage
        self.onLifeEnd = onLifeEnd
        self.isHit = isHit
        self.proximityScore = proximityScore
    }

    func updateState(currBeat: Double) {
        lifeStage = LifeStage(Lerper.linearFloat(from: 0, to: 1, t: abs(currBeat - lifeStart) / lifeTime))
        if currBeat - lifeStart >= lifeTime {
            destroyObject()
        }
    }

    func checkOnInput(input: InputData) {
//        checkOnInputEnd(input: input)
    }

    func checkOnInputEnd(input: InputData) {
        proximityScore += abs(lifeStage.value - lifeOptimal.value) * 2
    }
}

class BombGameHO: TapGameHO {
    static let missedProximityScore: Double = 2
    let isBomb = true

    convenience init(tapGameHO: TapGameHO) {
        let bombLifeEnd = tapGameHO.lifeEnd + 5

        self.init(wrappingObject: tapGameHO.wrappingObject, position: tapGameHO.position,
                  lifeStart: tapGameHO.lifeStart, lifeEnd: bombLifeEnd,
                  onLifeEnd: tapGameHO.onLifeEnd, proximityScore: tapGameHO.proximityScore)
    }

    override func checkOnInputEnd(input: InputData) {
        proximityScore = Self.missedProximityScore
    }
}
