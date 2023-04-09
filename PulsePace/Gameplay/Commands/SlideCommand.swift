//
//  SlideCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

class SlideCommand: InputCommand {
    override private init(action: @escaping InputCommand.Action, completion: InputCommand.Action? = nil) {
        super.init(action: action, completion: completion)
    }

    convenience init(receiver: SlideGameHO, eventManager: EventManager, timeReceived: Double) {
        self.init(
            action: { inputData in
                var inputData = inputData
                inputData.timeReceived = timeReceived
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
