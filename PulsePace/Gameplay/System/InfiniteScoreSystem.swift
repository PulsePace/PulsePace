//
//  InfiniteScoreSystem.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 10/4/23.
//

import Foundation

class InfiniteScoreSystem: ScoreSystem {
    override init(_ scoreManager: ScoreManager) {
        super.init(scoreManager)
        self.scoreManager.livesRemaining = 10
    }
    override func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(hitEventHandler)
        eventManager.registerHandler(missEventHandler)
    }

    override func reset() {
        super.reset()
        self.scoreManager.livesRemaining = 3
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
        } else {
            handleMiss(eventManager: eventManager)
        }
        gameHO.destroyObject()
    }

    lazy var missEventHandler = { [self] (eventManager: EventManagable, _: MissEvent) -> Void in
        handleMiss(eventManager: eventManager)
    }

    private func handleMiss(eventManager: EventManagable) {
        guard scoreManager.livesRemaining > 0 else {
            return
        }
        scoreManager.missCount += 1
        scoreManager.livesRemaining -= 1
        eventManager.add(event: LoseLifeEvent(timestamp: Date().timeIntervalSince1970))
        if scoreManager.livesRemaining == 0 {
            eventManager.add(event: DeathEvent(timestamp: Date().timeIntervalSince1970, diedPlayerId: ""))
        }
    }
}
