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

    func handleTap() {
        for handler in inputHandlers {
            handler.onTap()
        }
    }

    func handleSlideChanged() {
        for handler in inputHandlers {
            handler.onSlideChanged()
        }
    }

    func handleSlideEnded() {
        for handler in inputHandlers {
            handler.onSlideEnded()
        }
    }

    func handleHoldChanged() {
        for handler in inputHandlers {
            handler.onHoldChanged()
        }
    }

    func handleHoldEnded() {
        for handler in inputHandlers {
            handler.onHoldEnded()
        }
    }
}
