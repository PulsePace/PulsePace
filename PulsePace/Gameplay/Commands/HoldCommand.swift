//
//  HoldCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

class HoldCommand: InputCommand {
    override private init(action: @escaping InputCommand.Action, completion: InputCommand.Action? = nil) {
        super.init(action: action, completion: completion)
    }

    convenience init() {
        self.init { _ in
            print("Hold")
        }
    }
}

class HoldCommandHO: CommandHO {
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
