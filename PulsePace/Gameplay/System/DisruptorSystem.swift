//
//  DisruptorSystem.swift
//  PulsePace
//
//  Created by Charisma Kausar on 2/4/23.
//

import Foundation

class DisruptorSystem: ScoreSystem {
    var selectedTarget = UserConfig().userId
    var selectedDisruptor: Disruptor = .bomb

    var isEligibileToSendDisruptor: Bool {
        scoreManager.comboCount > 0 && scoreManager.comboCount.isMultiple(of: 5)
    }

    var spawnedDisruptorLocations: [CGPoint] = []

    var allScores: [String: Int] = [:]

    override init(_ scoreManager: ScoreManager) {
        super.init(scoreManager)
        self.scoreManager.livesRemaining = 3
    }

    override func reset() {
        super.reset()
        self.selectedTarget = UserConfig().userId
        self.selectedDisruptor = .bomb
        self.spawnedDisruptorLocations = []
        self.scoreManager.livesRemaining = 3
    }

    func setDisruptor(disruptor: Disruptor) {
        self.selectedDisruptor = disruptor
    }

    func setTarget(targetId: String) {
        self.selectedTarget = targetId
    }

    override func registerEventHandlers(eventManager: EventManagable) {
        super.registerEventHandlers(eventManager: eventManager)
        eventManager.registerHandler(updateComboHandler)
        eventManager.registerHandler(onSpawnBombDisruptorHandler)
        eventManager.registerHandler(bombHitEventHandler)
        eventManager.registerHandler(onUpdateScoreEventHandler)
    }

    lazy var updateComboHandler = { [self] (eventManager: EventManagable, event: UpdateComboEvent) -> Void in
        guard isEligibileToSendDisruptor else {
            return
        }
        eventManager.matchEventHandler?.publishMatchEvent(message: MatchEventMessage(
            timestamp: Date().timeIntervalSince1970, sourceId: UserConfig().userId,
            event: PublishDisruptorFactory().getPublishEvent(disruptor: selectedDisruptor,
                                                             targetId: selectedTarget,
                                                             location: event.lastLocation
                                                            )))
    }

    lazy var onSpawnBombDisruptorHandler = { [self] (_: EventManagable, event: SpawnBombDisruptorEvent) -> Void in
        guard event.bombTargetPlayerId == UserConfig().userId else {
            return
        }
        spawnedDisruptorLocations.append(event.bombLocation)
    }

    lazy var bombHitEventHandler = { [self] (eventManager: EventManagable, event: HitEvent) -> Void in
        guard !spawnedDisruptorLocations.allSatisfy({ event.gameHO.position != $0 }) else {
            return
        }
        self.scoreManager.comboCount = 0
        self.scoreManager.livesRemaining -= 1
        self.spawnedDisruptorLocations.removeAll(where: { $0 == event.gameHO.position })

        eventManager.add(event: LostLifeEvent(timestamp: Date().timeIntervalSince1970,
                                              lostLifePlayerId: UserConfig().userId))

        if self.scoreManager.livesRemaining == 0 {
            eventManager.matchEventHandler?.publishMatchEvent(
                message: MatchEventMessage(timestamp: Date().timeIntervalSince1970,
                                           sourceId: UserConfig().userId,
                                           event: PublishDeathEvent(timestamp: Date().timeIntervalSince1970,
                                                                    diedPlayerId: UserConfig().userId)))
        }
    }

    lazy var onUpdateScoreEventHandler = { [self] (_: EventManagable, event: UpdateScoreEvent) -> Void in
        allScores[event.playerId] = event.playerScore
    }
}

class PublishDisruptorFactory {
    func getPublishEvent(disruptor: Disruptor, targetId: String, location: CGPoint) -> any MatchEvent {
        if disruptor == .bomb {
            return PublishBombDisruptorEvent(timestamp: Date().timeIntervalSince1970,
                                             bombTargetId: targetId,
                                             bombLocation: location)
        } else if disruptor == .noHints {
            return PublishNoHintsDisruptorEvent(timestamp: Date().timeIntervalSince1970,
                                                noHintsTargetId: targetId,
                                                preSpawnInterval: 0.4,
                                                duration: 10)
        }
        fatalError("Specified disruptor does not exist")
    }
}

enum Disruptor: String, CaseIterable {
    case bomb = "Bomb"
    case noHints = "No Hints"
}
