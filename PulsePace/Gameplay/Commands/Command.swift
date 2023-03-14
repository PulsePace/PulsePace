//
//  Command.swift
//  PulsePace
//
//  Referenced from: https://khawerkhaliq.com/blog/swift-command-pattern/
//  Created by Charisma Kausar on 8/3/23.
//

import SwiftUI

/// Command to checks input against state of game hit object and maintain some macro data on input related state
/// e.g. for slider the aggregate proximity to the expected position
protocol Command {
    // If the above mentioned is acceptable archi perhaps Command is not the most suitable name?
    associatedtype GameHOType: GameHO
    var shouldExecute: Bool { get set }
    var currInput: InputData? { get set }

    func execute(gameHO: GameHOType, deltaTime: Double)
}
