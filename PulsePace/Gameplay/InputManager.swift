//
//  InputManager.swift
//  PulsePace
//
//  Created by Charisma Kausar on 19/3/23.
//

class InputManager {
    var inputHandlers: [InputHandler] = []

    func addHandler(handler: InputHandler) {
        inputHandlers.append(handler)
    }

    func removeHandler(handler: InputHandler) {
        guard let handlerIndex = inputHandlers.firstIndex(where: { $0 === handler }) else {
            return
        }
        inputHandlers.remove(at: handlerIndex)
    }

    func handleTap(gameHO: any GameHO, input: InputData) {
        for handler in inputHandlers {
            handler.onTap(gameHO: gameHO, input: input)
        }
    }

    func handleSlideChanged(gameHO: any GameHO, input: InputData) {
        for handler in inputHandlers {
            handler.onSlideChanged(gameHO: gameHO, input: input)
        }
    }

    func handleSlideEnded(gameHO: any GameHO, input: InputData) {
        for handler in inputHandlers {
            handler.onSlideEnded(gameHO: gameHO, input: input)
        }
    }

    func handleHoldChanged(gameHO: any GameHO, input: InputData) {
        for handler in inputHandlers {
            handler.onHoldChanged(gameHO: gameHO, input: input)
        }
    }

    func handleHoldEnded(gameHO: any GameHO, input: InputData) {
        for handler in inputHandlers {
            handler.onHoldEnded(gameHO: gameHO, input: input)
        }
    }
}
