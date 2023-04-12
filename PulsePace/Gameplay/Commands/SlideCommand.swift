//
//  SlideCommand.swift
//  PulsePace
//
//  Created by Charisma Kausar on 9/3/23.
//

import CoreGraphics

class SlideCommand: InputCommand {
    override private init(action: @escaping InputCommand.Action, completion: InputCommand.Action? = nil) {
        super.init(action: action, completion: completion)
    }

    convenience init(receiver: SlideGameHO, eventManager: EventManager, timeReceived: Double, frame: CGSize) {
        self.init(
            action: { inputData in
                let xTr = (frame.width - 640) / 2
                let yTr = (frame.height - 480) / 2
                let location = Location(location: CGPoint(x: inputData.location.x - xTr,
                                                          y: inputData.location.y - yTr))
                var inputData = InputData(value: location)
                inputData.timeReceived = timeReceived
                eventManager.add(event: InputEvent(inputData: inputData,
                                                   gameHO: receiver,
                                                   timestamp: timeReceived,
                                                   isEndingInput: false))
            },
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

class Location: Locatable {
    var location: CGPoint

    init(location: CGPoint) {
        self.location = location
    }
}
