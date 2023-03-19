//
//  ScoreManager.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 15/3/23.
//

class ScoreManager {
    var score: Int = 0
    var perfetHitCount: Int {
        didSet {
            comboCount += perfetHitCount - oldValue
        }
    }
    var goodHitCount: Int {
        didSet {
            comboCount += goodHitCount - oldValue
        }
    }
    var missCount: Int {
        didSet {
            comboCount = 0
        }
    }

    var comboCount: Int = 0

    init() {
        perfetHitCount = 0
        goodHitCount = 0
        missCount = 0
    }
}

extension ScoreManager: InputHandler {
    func onInputChanged(gameHO: any GameHO, input: InputData) {
        gameHO.checkOnInput(input: input, scoreManager: self)
    }
    func onInputEnded(gameHO: any GameHO, input: InputData) {
        gameHO.checkOnInputEnd(input: input, scoreManager: self)
    }
}
