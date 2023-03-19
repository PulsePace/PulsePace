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

    convenience init(receiver: HoldGameHO, timeReceived: Double) {
        self.init(
            action: { inputData in
                var inputData = inputData
                inputData.timeReceived = timeReceived
                print("Hold")
//                receiver.checkOnInput(inputData: inputData)
            },
            completion: { inputData in
                var inputData = inputData
                inputData.timeReceived = timeReceived
//                receiver.checkOnInputEnd(inputData: inputData)
            }
        )
    }
}
