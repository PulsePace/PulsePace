//
//  ScoreSystem.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

import Foundation

class ScoreSystem: System {
    var proximityScoreThreshould = [0.5, 1]
    var scoreManager: ScoreManager?

    init(scoreManager: ScoreManager? = nil) {
        self.scoreManager = scoreManager
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(hitEventHandler)
    }

    lazy var hitEventHandler = { [self] (eventManager: EventManagable, event: HitEvent) -> Void in
        guard let scoreManager = scoreManager else {
            return
        }
        let gameHO = event.gameHO
        if gameHO.proximityScore < proximityScoreThreshould[0] {
            scoreManager.perfectCount += 1
            scoreManager.score += 100
            eventManager.add(event: UpdateComboEvent(timestamp: Date().timeIntervalSince1970,
                                                     comboCount: scoreManager.comboCount,
                                                     lastLocation: gameHO.position
                                                    ))
        } else if gameHO.proximityScore < proximityScoreThreshould[1] {
            scoreManager.goodCount += 1
            scoreManager.score += 50
        } else {
            scoreManager.missCount += 1
            scoreManager.score += 10
        }
    }
}
