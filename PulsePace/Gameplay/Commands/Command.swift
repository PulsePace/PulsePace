//
//  Command.swift
//  PulsePace
//
//  Referenced from: https://khawerkhaliq.com/blog/swift-command-pattern/
//  Created by Charisma Kausar on 8/3/23.
//

import SwiftUI

class Command {
    typealias Action = (InputData) -> Void

    private let action: Action

    init(action: @escaping Action) {
        self.action = action
    }

    func execute(inputData: InputData) {
        action(inputData)
    }
}
