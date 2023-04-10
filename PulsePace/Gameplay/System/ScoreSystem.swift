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

    func getGameEndScore() -> Int {
        scoreManager.score
    }

    func reset() {
        scoreManager = ScoreManager()
    }

    init(_ scoreManager: ScoreManager) {
        self.scoreManager = scoreManager
    }

    func attachToMatch(_ match: Match) {}

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(hitEventHandler)
        eventManager.registerHandler(missEventHandler)
    }

    lazy var hitEventHandler = { [self] (eventManager: EventManagable, event: HitEvent) -> Void in
        let gameHO = event.gameHO
        gameHO.isHit = true
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
            eventManager.add(event: UpdateComboEvent(timestamp: Date().timeIntervalSince1970,
                                                     comboCount: scoreManager.comboCount,
                                                     lastLocation: gameHO.position
                                                    ))
            gameHO.isHit = true
        } else {
            scoreManager.missCount += 1
        }
        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }
        eventManager.matchEventHandler?.publishMatchEvent(
            message: MatchEventMessage(timestamp: Date().timeIntervalSince1970,
                                       sourceId: userConfigManager.userId,
                                       event: PublishScoreEvent(timestamp: Date().timeIntervalSince1970,
                                                                playerScore: scoreManager.score)))
        gameHO.destroyObject()
    }
    lazy var missEventHandler = { [self] (_: EventManagable, event: MissEvent) -> Void in
        let gameHO = event.gameHO
        scoreManager.missCount += 1
    }
}
