//
//  InputSystem.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

import Foundation

class InputSystem: System {

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(inputEventHandler)
    }

    private lazy var inputEventHandler = { [self] (eventManager: EventManagable, event: InputEvent) -> Void in
        if event.isEndingInput {
            event.gameHO.checkOnInputEnd(input: event.inputData)
            eventManager.add(event: HitEvent(gameHO: event.gameHO, timestamp: Date().timeIntervalSince1970))
        } else {
            event.gameHO.checkOnInput(input: event.inputData)
        }
    }
}
