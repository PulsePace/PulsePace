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
            latestHitStatus = .perfect
        }
    }
    var goodCount: Int {
        didSet {
            comboCount += goodCount - oldValue
            latestHitStatus = .good
        }
    }
    var missCount: Int {
        didSet {
            comboCount = 0
            latestHitStatus = .miss
        }
    }

    var comboCount: Int = 0

    var latestHitStatus: HitStatus?

    init() {
        score = 0
        perfectCount = 0
        goodCount = 0
        missCount = 0
        livesRemaining = 1
    }
}
