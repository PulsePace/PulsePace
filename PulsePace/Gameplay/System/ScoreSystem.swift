//
//  ScoreSystem.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

class ScoreSystem: System {
    var proximityScoreThreshould = [0.5, 1]
    var scoreManager: ScoreManager

    init(scoreManager: ScoreManager) {
        self.scoreManager = scoreManager
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(hitEventHandler)
    }

    private lazy var hitEventHandler = { [self] (_: EventManagable, event: HitEvent) -> Void in
        let gameHO = event.gameHO
        if gameHO.proximityScore < proximityScoreThreshould[0] {
            scoreManager.perfectCount += 1
            scoreManager.score += 100
        } else if gameHO.proximityScore < proximityScoreThreshould[1] {
            scoreManager.goodCount += 1
            scoreManager.score += 50
        } else {
            scoreManager.missCount += 1
            scoreManager.score += 10
        }
    }
}
