//
//  MatchFeedSystem.swift
//  PulsePace
//
//  Created by Charisma Kausar on 1/4/23.
//

import Foundation

class MatchFeedSystem: System {
    let messageBuilder: MessageBuilder
    var maxMatchFeedMessagesCount = 2

    var matchFeedMessages: PriorityQueue<MatchFeedMessage> = PriorityQueue<MatchFeedMessage>(
        sortBy: { x, y in x.timestamp < y.timestamp })

    init(playerNames: [String: String] = [:]) {
        self.messageBuilder = MessageBuilder(playerNames: playerNames)
        self.setupMessageConfigs()
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(spawnBombDisruptorHandler)
        eventManager.registerHandler(activateNoHintsDisruptorHandler)
        eventManager.registerHandler(deathHandler)
        eventManager.registerHandler(lostlifeHandler)
    }

    private lazy var spawnBombDisruptorHandler
    = { [self] (_: EventManagable, event: SpawnBombDisruptorEvent) -> Void in
        let message = messageBuilder
            .setEventType(type(of: event).label)
            .setSource(event.bombSourcePlayerId)
            .setTarget(event.bombTargetPlayerId)
            .build()

        let matchFeedMessage = MatchFeedMessage(message: message, timestamp: Date().timeIntervalSince1970)
        addToMatchFeed(message: matchFeedMessage)
    }

    private lazy var activateNoHintsDisruptorHandler
    = { [self] (_: EventManagable, event: ActivateNoHintsDisruptorEvent) -> Void in
        let message = messageBuilder
            .setEventType(type(of: event).label)
            .setSource(event.noHintsSourcePlayerId)
            .setTarget(event.noHintsTargetPlayerId)
            .build()

        let matchFeedMessage = MatchFeedMessage(message: message, timestamp: Date().timeIntervalSince1970)
        addToMatchFeed(message: matchFeedMessage)
    }

    private lazy var deathHandler
    = { [self] (_: EventManagable, event: DeathEvent) -> Void in
        let message = messageBuilder
            .setEventType(type(of: event).label)
            .setSource(event.diedPlayerId)
            .build()

        let matchFeedMessage = MatchFeedMessage(message: message, timestamp: Date().timeIntervalSince1970)
        addToMatchFeed(message: matchFeedMessage)
    }

    private lazy var lostlifeHandler
    = { [self] (_: EventManagable, event: LostLifeEvent) -> Void in
        let message = messageBuilder
            .setEventType(type(of: event).label)
            .build()

        let matchFeedMessage = MatchFeedMessage(message: message, timestamp: Date().timeIntervalSince1970)
        addToMatchFeed(message: matchFeedMessage)
    }

    private func addToMatchFeed(message: MatchFeedMessage) {
        matchFeedMessages.enqueue(message)
        if matchFeedMessages.count > maxMatchFeedMessagesCount {
            _ = matchFeedMessages.dequeue()
        }
    }

    private func setupMessageConfigs() {
        messageBuilder.addEventMessageConfig(eventType: SpawnBombDisruptorEvent.label,
                                             messageConfig: SpawnBombDisruptorMessageConfig())
        messageBuilder.addEventMessageConfig(eventType: ActivateNoHintsDisruptorEvent.label,
                                             messageConfig: ActivateNoHintsDisruptorMessageConfig())
        messageBuilder.addEventMessageConfig(eventType: DeathEvent.label,
                                             messageConfig: DeathMessageConfig())
        messageBuilder.addEventMessageConfig(eventType: LostLifeEvent.label,
                                             messageConfig: LostLifeMessageConfig())
    }
}

struct MatchFeedMessage {
    var message: String
    var timestamp: Double
}
