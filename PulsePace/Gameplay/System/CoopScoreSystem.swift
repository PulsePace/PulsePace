//
//  CoopScoreSystem.swift
//  PulsePace
//
//  Created by James Chiu on 10/4/23.
//

import Foundation

class CoopScoreSystem: ScoreSystem {
    var allScores: [String: Int] = [:]
    override func registerEventHandlers(eventManager: EventManagable) {
        super.registerEventHandlers(eventManager: eventManager)
        eventManager.registerHandler(completeGameHandler)
    }

    override func reset() {
        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }

        super.reset()
        self.allScores = [:]
    }

    override func attachToMatch(_ match: Match) {
        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }

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