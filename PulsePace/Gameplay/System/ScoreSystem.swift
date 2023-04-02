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

    // TODO: Probably best to allow scoreManager to handle score update instead of direct access (cater for different score mode)
    private lazy var hitEventHandler = { [weak self] (_: EventManagable, event: HitEvent) -> Void in
        guard let self = self else {
            fatalError("No active score system")
        }
        let gameHO = event.gameHO
        if gameHO.proximityScore < self.proximityScoreThreshould[0] {
            self.scoreManager.perfectCount += 1
            self.scoreManager.score += 100
        } else if gameHO.proximityScore < self.proximityScoreThreshould[1] {
            self.scoreManager.goodCount += 1
            self.scoreManager.score += 50
        } else {
            self.scoreManager.missCount += 1
            self.scoreManager.score += 10
        }
    }
}
