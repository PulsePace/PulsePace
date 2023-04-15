//
//  DisruptorSystem.swift
//  PulsePace
//
//  Created by Charisma Kausar on 2/4/23.
//

import Foundation

class DisruptorSystem: ScoreSystem {
    static let defaultLifeCount = 3
    var selectedTarget: String
    var selectedDisruptor: Disruptor = .bomb

    var isEligibileToSendDisruptor: Bool {
        scoreManager.comboCount > 0 && scoreManager.comboCount.isMultiple(of: 5)
    }

    var spawnedDisruptorLocations: [CGPoint] = []

    var allScores: [String: Int] = [:]
    var allRemainingPlayers: [String: Bool] = [:]

    override init(_ scoreManager: ScoreManager) {
        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }

        self.selectedTarget = userConfigManager.userId
        super.init(scoreManager)
        self.scoreManager.livesRemaining = Self.defaultLifeCount
    }

    override func attachToMatch(_ match: Match) {
        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }

        selectedTarget = match.players.first(where: { $0.key != userConfigManager.userId })?.key
        ?? userConfigManager.userId
        match.players.forEach({ allScores[$0.key] = 0 })
        match.players.forEach({ allRemainingPlayers[$0.key] = true })

    }

    override func reset() {
        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }

        super.reset()
        self.selectedTarget = userConfigManager.userId
        self.selectedDisruptor = .bomb
        self.spawnedDisruptorLocations = []
        self.scoreManager.livesRemaining = Self.defaultLifeCount
        self.allScores = [:]
        self.allRemainingPlayers = [:]
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
        eventManager.registerHandler(onDeathEventHandler)
    }

    lazy var updateComboHandler = { [self] (eventManager: EventManagable, event: UpdateComboEvent) -> Void in
        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }

        guard isEligibileToSendDisruptor else {
            return
        }
        eventManager.matchEventHandler?.publishMatchEvent(message: MatchEventMessage(
            timestamp: Date().timeIntervalSince1970, sourceId: userConfigManager.userId,
            event: PublishDisruptorFactory().getPublishEvent(disruptor: selectedDisruptor,
                                                             targetId: selectedTarget,
                                                             location: event.lastLocation
                                                            )))
    }

    lazy var onSpawnBombDisruptorHandler = { [self] (_: EventManagable, event: SpawnBombDisruptorEvent) -> Void in
        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }

        guard event.bombTargetPlayerId == userConfigManager.userId else {
            return
        }
        spawnedDisruptorLocations.append(event.bombLocation)
    }

    lazy var bombHitEventHandler = { [self] (eventManager: EventManagable, event: HitEvent) -> Void in
        guard let userConfigManager = UserConfigManager.instance else {
            fatalError("No user config manager")
        }

        guard !spawnedDisruptorLocations.allSatisfy({ event.gameHO.position != $0 }),
              self.scoreManager.livesRemaining > 0
        else {
            return
        }

        self.scoreManager.comboCount = 0
        self.scoreManager.livesRemaining -= 1
        self.spawnedDisruptorLocations.removeAll(where: { $0 == event.gameHO.position })

        eventManager.add(event: LostLifeEvent(timestamp: Date().timeIntervalSince1970))

        if self.scoreManager.livesRemaining == 0 {
            eventManager.add(event: SelfDeathEvent(timestamp: Date().timeIntervalSince1970))
        }
    }

    lazy var onUpdateScoreEventHandler = { [self] (_: EventManagable, event: UpdateScoreEvent) -> Void in
        allScores[event.playerId] = event.playerScore
    }

    lazy var onDeathEventHandler = { [self] (eventManager: EventManagable, event: DeathEvent) -> Void in
        allRemainingPlayers[event.diedPlayerId] = false
        if allRemainingPlayers.values.filter({ $0 }).count == 1 {
            eventManager.add(event: OnlyRemainingPlayerEvent(timestamp: Date().timeIntervalSince1970))
        }
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
