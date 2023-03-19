//
//  TapCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

class TapCommand: InputCommand {
    override private init(action: @escaping InputCommand.Action, completion: InputCommand.Action? = nil) {
        super.init(action: action, completion: completion)
    }

    convenience init(receiver: TapGameHO) {
        self.init { _ in
            print("Tap")
//            receiver.checkOnInput(inputData: inputData)
        }
    }
}
