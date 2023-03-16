//
//  HoldCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

class HoldCommand: Command {
    typealias GameHOType = HoldGameHO
    var shouldExecute = false
    var currInput: InputData?
    var normalizedHoldTime: Double = 0
    var isHit = false
    var holdStart: LifeStage?

    func execute(gameHO: HoldGameHO, deltaTime: Double) {
        if holdStart == nil {
            holdStart = gameHO.lifeStage
        }
        normalizedHoldTime += deltaTime / gameHO.lifeOptimal
    }
}
