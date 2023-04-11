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

    convenience init(receiver: TapGameHO, eventManager: EventManager, timeReceived: Double) {
        self.init(
            action: { _ in },
            completion: { inputData in
                var inputData = inputData
                inputData.timeReceived = timeReceived
                eventManager.add(event: InputEvent(inputData: inputData,
                                                   gameHO: receiver,
                                                   timestamp: timeReceived,
                                                   isEndingInput: true))
            }
        )
    }
}
