//
//  GameHitObject.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

protocol GameHO: Component, AnyObject {
    var fromPartner: Bool { get set }

    var position: CGPoint { get }
    var lifeStart: Double { get }
    // lifestage is clamped between 0 and 1, 0.5 being the optimal
    var lifeStage: LifeStage { get }
    var lifeEnd: Double { get }

    var isHit: Bool { get set }
    var proximityScore: Double { get }

    func updateState(currBeat: Double)

    func checkOnInput(input: InputData)
    func checkOnInputEnd(input: InputData)
}

extension GameHO {
    var lifeTime: Double {
        lifeEnd - lifeStart
    }

}

protocol Component {
    var wrappingObject: Entity { get }
//    var onLifeEnd: (EventManagable) -> Void { get }
}

extension Component {
    func destroyObject() {
        wrappingObject.destroy()
//        onLifeEnd()
    }
}

struct LifeStage {
    static let endStage = LifeStage(1.0)
    static let startStage = LifeStage(0.0)
    let value: Double

    init(_ stage: Double) {
        self.value = Math.clamp(num: stage, minimum: 0, maximum: 1)
    }
}
