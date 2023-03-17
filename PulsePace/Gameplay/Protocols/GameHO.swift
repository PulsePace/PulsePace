//
//  GameHitObject.swift
//  PulsePace
//
//  Created by James Chiu on 13/3/23.
//

import Foundation

/// Independent from input state, the command holds the
protocol GameHO: Component, AnyObject, ScoreManagable {
    associatedtype CommandType: CommandHO
    var command: CommandType { get set }
    var lifeStart: Double { get }
    // lifestage is clamped between 0 and 1, 0.5 being the optimal
    var lifeStage: LifeStage { get }
    var lifeTime: Double { get }

    func updateState(currBeat: Double)
}

extension GameHO {
    var shouldExecute: Bool {
        command.shouldExecute
    }

    func prepToProcessInput(inputData: InputData) {
        command.shouldExecute = true
        command.currInput = inputData
    }

    // Used for like onDragEnd, onTapEnd etc.
    func onInputCease() {
        command.shouldExecute = false
        command.currInput = nil
    }

    func processInput(deltaTime: Double) {
        guard let selfHO = self as? Self.CommandType.GameHOType else {
            print("Command type and hit object type should form an  enclosed pair")
            return
        }
        command.execute(gameHO: selfHO, deltaTime: deltaTime)
    }
}

protocol Component {
    var wrappingObject: Entity { get }
    // List of callbacks to invoke when gameHO is destroyed (scoreSystem)
    var onLifeEnd: [(Self) -> Void] { get }
}

extension Component {
    func destroyObject() {
        wrappingObject.destroy()
        onLifeEnd.forEach { $0(self) }
    }
}

struct LifeStage {
    static let endStage = LifeStage(1.0)
    static let startStage = LifeStage(0.0)
    let stage: Double
    var isOptimal: Bool {
        stage == 0.5
    }

    init(_ stage: Double) {
        self.stage = Math.clamp(num: stage, minimum: 0, maximum: 1)
    }
}
