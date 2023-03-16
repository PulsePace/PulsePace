//
//  TapCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

class TapCommand: InputCommand {
    convenience init() {
        self.init { _ in
            print("Tap")
        }
    }
}

class TapCommandHO: CommandHO {
    typealias GameHOType = TapGameHO

    var shouldExecute = false
    var currInput: InputData?
    var isHit = false
    var hitStage = LifeStage.startStage

    func execute(gameHO: TapGameHO, deltaTime: Double) {
        // Only first tap registers
        if isHit {
            return
        }

        isHit = true
        hitStage = gameHO.lifeStage
        // TODO: Animation after destroying entity object
        gameHO.destroyObject()
    }
}
