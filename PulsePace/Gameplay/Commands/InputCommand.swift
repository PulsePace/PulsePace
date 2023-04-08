//
//  InputCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 8/3/23.
//

class InputCommand: Command {
    typealias ActionArguments = InputData
    var action: Action
    var completion: Action?

    init(action: @escaping Action, completion: Action? = nil) {
        self.action = action
        self.completion = completion ?? action
    }

    func executeCompletion(inputData: InputData) {
        (completion ?? action)(inputData)
    }
}
