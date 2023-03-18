//
//  Command.swift
//  PulsePace
//
//  Referenced from: https://khawerkhaliq.com/blog/swift-command-pattern/
//  Created by Charisma Kausar on 15/3/23.
//

import SwiftUI

protocol Command {
    associatedtype ActionArguments
    typealias Action = (ActionArguments) -> Void
    var action: Action { get }
    func executeAction(inputData: ActionArguments)
}

extension Command {
    func executeAction(inputData: ActionArguments) {
        action(inputData)
    }
}

/// Command to checks input against state of game hit object and maintain some macro data on input related state
/// e.g. for slider the aggregate proximity to the expected position
protocol CommandHO {
    // If the above mentioned is acceptable archi perhaps Command is not the most suitable name?
    associatedtype GameHOType: GameHO
    var shouldExecute: Bool { get set }
    var currInput: InputData? { get set }

    func execute(gameHO: GameHOType, deltaTime: Double)
}
