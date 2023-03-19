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

    convenience init(receiver: HoldGameHO) {
        self.init(
            action: { _ in
                print("Hold")
//                receiver.checkOnInput(inputData: inputData)
            },
            completion: { _ in
//                receiver.checkOnInputEnd(inputData: inputData)
            }
        )
    }
}
