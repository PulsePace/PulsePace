//
//  ScoreSystem.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

class ScoreSystem: System {
    var proximityScoreThreshould = [0.5, 1]
    var scoreManager: ScoreManager?

    init(scoreManager: ScoreManager? = nil) {
        self.scoreManager = scoreManager
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(hitEventHandler)
    }

    /* TODO: Probably best to allow scoreManager to handle score update
     instead of direct access (cater for different score mode) */
    private lazy var hitEventHandler = { [self] (_: EventManagable, event: HitEvent) -> Void in
        guard let scoreManager = scoreManager else {
            return
        }
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

class CompetitiveScoreSystem: ScoreSystem {

}
