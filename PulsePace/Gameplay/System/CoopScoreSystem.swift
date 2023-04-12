//
//  CoopScoreSystem.swift
//  PulsePace
//
//  Created by James Chiu on 10/4/23.
//

import Foundation

class CoopScoreSystem: ScoreSystem {
    var allScores: [String: Int] = [:]

    override func getGameEndScore() -> Int {
        allScores.values.reduce(0, { $0 + $1 })
    }

    override func registerEventHandlers(eventManager: EventManagable) {
        super.registerEventHandlers(eventManager: eventManager)
        eventManager.registerHandler(onUpdateScoreEventHandler)
        eventManager.registerHandler(completeGameHandler)
    }

    override func reset() {
        super.reset()
        self.allScores = [:]
    }

    override func attachToMatch(_ match: Match) {
        match.players.forEach({ allScores[$0.key] = 0 })
    }

    private lazy var completeGameHandler = { [weak self] (eventManager: EventManagable, event: LastHitobjectRemovedEvent) -> Void in
        guard let self = self else {
            fatalError("No coop score system")
        }

        eventManager.add(event: GameCompleteEvent(timestamp: event.timestamp, finalScore: self.scoreManager.score))
    }

    private lazy var onUpdateScoreEventHandler = { [self] (_: EventManagable, event: UpdateScoreEvent) -> Void in
        allScores[event.playerId] = event.playerScore
    }
}
