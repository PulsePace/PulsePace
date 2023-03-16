//
//  InputCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 8/3/23.
//

import SwiftUI

class InputCommand: Command {
    typealias Action = (InputData) -> Void
    var action: Action
    var completion: Action?

    init(action: @escaping Action, completion: Action? = nil) {
        self.action = action
        self.completion = completion ?? action
    }

    func executeOnEnded(inputData: InputData) {
        (completion ?? action)(inputData)
    }
}
