//
//  ScoreManager.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 15/3/23.
//

// TODO: Make ScoreManager a protocol
class ScoreManager {
    var score: Int
    var livesRemaining: Int
    var perfectCount: Int {
        didSet {
            comboCount += perfectCount - oldValue
        }
    }
    var goodCount: Int {
        didSet {
            comboCount += goodCount - oldValue
        }
    }
    var missCount: Int {
        didSet {
            comboCount = 0
        }
    }

    var comboCount: Int = 0

    init() {
        score = 0
        perfectCount = 0
        goodCount = 0
        missCount = 0
        livesRemaining = 1
    }
}
