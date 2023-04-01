//
//  MatchFeedSystem.swift
//  PulsePace
//
//  Created by Charisma Kausar on 1/4/23.
//

import Foundation

class MatchFeedSystem: System {
    let messageBuilder: MessageBuilder

    init() {
        // TODO: Get actual player names
        self.messageBuilder = MessageBuilder(playerNames: ["123": "Player123", "456": "Player456"])
        self.setupMessageConfigs()
    }

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(announceFeedHandler)
        eventManager.registerHandler(spawnBombDisruptorHandler)
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

        eventManager.add(event: AnnounceFeedEvent(timestamp: Date().timeIntervalSince1970, message: message))
    }

    private func setupMessageConfigs() {
        messageBuilder.addEventMessageConfig(eventType: SpawnBombDisruptorEvent.label,
                                             messageConfig: SpawnBombDisruptorMessageConfig())
    }
}

struct AnnounceFeedEvent: Event {
    var timestamp: Double
    var message: String
}
