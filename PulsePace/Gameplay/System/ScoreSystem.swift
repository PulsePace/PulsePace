//
//  ScoreSystem.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

import Foundation

class ScoreSystem: ModeSystem {
    var proximityScoreThreshould = [0.5, 1]
    var scoreManager: ScoreManager

    func reset() {
        scoreManager = ScoreManager()
    }

    init(_ scoreManager: ScoreManager) {
        self.scoreManager = scoreManager
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(hitEventHandler)
    }

    lazy var hitEventHandler = { [self] (eventManager: EventManagable, event: HitEvent) -> Void in
        let gameHO = event.gameHO
        if gameHO.proximityScore < proximityScoreThreshould[0] {
            if let tapGameHO = gameHO as? TapGameHO {
                print("Tap object perfect hit")
            }
            scoreManager.perfectCount += 1
            scoreManager.score += 100
            eventManager.add(event: UpdateComboEvent(timestamp: Date().timeIntervalSince1970,
                                                     comboCount: scoreManager.comboCount,
                                                     lastLocation: gameHO.position
                                                    ))
            gameHO.isHit = true
        } else if gameHO.proximityScore < proximityScoreThreshould[1] {
            scoreManager.goodCount += 1
            scoreManager.score += 50
            eventManager.add(event: UpdateComboEvent(timestamp: Date().timeIntervalSince1970,
                                                     comboCount: scoreManager.comboCount,
                                                     lastLocation: gameHO.position
                                                    ))
            gameHO.isHit = true
        } else {
            scoreManager.missCount += 1
            scoreManager.score += 10
        }
        eventManager.matchEventHandler?.publishMatchEvent(
            message: MatchEventMessage(timestamp: Date().timeIntervalSince1970,
                                       sourceId: UserConfig().userId,
                                       event: PublishScoreEvent(timestamp: Date().timeIntervalSince1970,
                                                                playerScore: scoreManager.score)))
    }
}
