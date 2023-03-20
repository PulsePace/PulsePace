//
//  InputHandler.swift
//  PulsePace
//
//  Created by Charisma Kausar on 19/3/23.
//

protocol InputHandler: AnyObject {
    func onInputChanged(gameHO: any GameHO, input: InputData)
    func onInputEnded(gameHO: any GameHO, input: InputData)
    func onTap(gameHO: any GameHO, input: InputData)
    func onSlideChanged(gameHO: any GameHO, input: InputData)
    func onSlideEnded(gameHO: any GameHO, input: InputData)
    func onHoldChanged(gameHO: any GameHO, input: InputData)
    func onHoldEnded(gameHO: any GameHO, input: InputData)
}

extension InputHandler {
    func onTap(gameHO: any GameHO, input: InputData) {
        onInputChanged(gameHO: gameHO, input: input)
    }
    func onSlideChanged(gameHO: any GameHO, input: InputData) {
        onInputChanged(gameHO: gameHO, input: input)
    }

    func onSlideEnded(gameHO: any GameHO, input: InputData) {
        onInputEnded(gameHO: gameHO, input: input)
    }

    func onHoldChanged(gameHO: any GameHO, input: InputData) {
        onInputChanged(gameHO: gameHO, input: input)
    }

    func onHoldEnded(gameHO: any GameHO, input: InputData) {
        onInputEnded(gameHO: gameHO, input: input)
    }
}
