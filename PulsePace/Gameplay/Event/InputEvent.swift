//
//  InputEvent.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

struct InputEvent: Event {
    var timestamp: Double = 0.0
    var gameHO: any GameHO
    var inputData: InputData
    var isEndingInput: Bool

    init(inputData: InputData, gameHO: any GameHO, timestamp: Double, isEndingInput: Bool) {
        self.inputData = inputData
        self.gameHO = gameHO
        self.timestamp = timestamp
        self.isEndingInput = isEndingInput
    }
}
