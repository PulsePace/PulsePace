//
//  MatchFeedSystem.swift
//  PulsePace
//
//  Created by Charisma Kausar on 1/4/23.
//

import Foundation

class MatchFeedSystem: System {
    let messageBuilder: MessageBuilder

    var matchFeedMessages: PriorityQueue<MatchFeedMessage> = PriorityQueue<MatchFeedMessage>(
        sortBy: { x, y in x.timestamp < y.timestamp })

    init() {
        // TODO: Get actual player names
        self.messageBuilder = MessageBuilder(playerNames: ["123": "Player123", "456": "Player456"])
        self.setupMessageConfigs()
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(announceFeedHandler)
        eventManager.registerHandler(spawnBombDisruptorHandler)
        eventManager.registerHandler(activateNoHintsDisruptorHandler)
    }

    private lazy var announceFeedHandler = { [self] (_: EventManagable, event: AnnounceFeedEvent) -> Void in
        print(event.message)
    }

    private lazy var
    spawnBombDisruptorHandler = { [self] (eventManager: EventManagable, event: SpawnBombDisruptorEvent) -> Void in
        let message = messageBuilder
            .setEventType(type(of: event).label)
            .setSource(event.bombSourcePlayerId)
            .setTarget(event.bombTargetPlayerId)
            .build()

        let matchFeedMessage = MatchFeedMessage(message: message, timestamp: Date().timeIntervalSince1970)
        addToMatchFeed(message: matchFeedMessage)

        eventManager.add(event: AnnounceFeedEvent(timestamp: Date().timeIntervalSince1970, message: message))
    }

    private lazy var activateNoHintsDisruptorHandler = { [self] (eventManager: EventManagable,
                                                                 event: ActivateNoHintsDisruptorEvent) -> Void in
        let message = messageBuilder
            .setEventType(type(of: event).label)
            .setSource(event.noHintsSourcePlayerId)
            .setTarget(event.noHintsTargetPlayerId)
            .build()

        let matchFeedMessage = MatchFeedMessage(message: message, timestamp: Date().timeIntervalSince1970)
        addToMatchFeed(message: matchFeedMessage)

        eventManager.add(event: AnnounceFeedEvent(timestamp: Date().timeIntervalSince1970, message: message))
    }

    private func addToMatchFeed(message: MatchFeedMessage) {
        matchFeedMessages.enqueue(message)
        if matchFeedMessages.count > 10 {
            _ = matchFeedMessages.dequeue()
        }
    }

    private func setupMessageConfigs() {
        messageBuilder.addEventMessageConfig(eventType: SpawnBombDisruptorEvent.label,
                                             messageConfig: SpawnBombDisruptorMessageConfig())
        messageBuilder.addEventMessageConfig(eventType: ActivateNoHintsDisruptorEvent.label,
                                             messageConfig: ActivateNoHintsDisruptorMessageConfig())
    }
}

struct AnnounceFeedEvent: Event {
    var timestamp: Double
    var message: String
}

struct MatchFeedMessage {
    var message: String
    var timestamp: Double
}
