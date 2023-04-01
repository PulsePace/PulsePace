//
//  MatchFeedSystem.swift
//  PulsePace
//
//  Created by Charisma Kausar on 1/4/23.
//

import Foundation

/// *
/// Expected messages:
/// 1. Charisma threw a bomb at Peter
/// 2. Yuanxi died from a bomb
/// 3. James gave Charisma slow hints
/// 4. Charisma hit a bomb
///

class MatchFeedSystem: System {
    let messageBuilder: MessageBuilder

    init() {
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

class MessageBuilder {
    private var playerNames: [String: String]

    private var sourcePlayer: String?
    private var targetPlayer: String?
    private var eventType: String?

    private var eventMessageConfig: MessageConfig?

    private let unknownPlayer = "Anonymous"
    private let unknownValue = "Unknown"

    // [placeholder: (valueToReplaceWith?, defaultValue)]
    private var placeholders: [String: (String?, String)] {
        ["{sourcePlayer}": (sourcePlayer, unknownPlayer),
         "{targetPlayer}": (targetPlayer, unknownPlayer)]
    }

    private var messageConfigs: [String: MessageConfig] = [:]

    init(playerNames: [String: String]) {
        self.playerNames = playerNames
    }

    func addEventMessageConfig(eventType: String, messageConfig: MessageConfig) {
        messageConfigs[eventType] = messageConfig
        messageConfig.requiredPlaceholders.forEach({ assert(placeholders[$0] != nil) })
    }

    func setEventType(_ eventType: String) -> MessageBuilder {
        self.eventType = eventType
        self.eventMessageConfig = messageConfigs[eventType]
        return self
    }

    func setSource(_ sourcePlayerId: String) -> MessageBuilder {
        self.sourcePlayer = playerNames[sourcePlayerId]
        return self
    }

    func setTarget(_ targetPlayerId: String) -> MessageBuilder {
        self.targetPlayer = playerNames[targetPlayerId]
        return self
    }

    func build() -> String {
        var message = ""

        guard let messageFormat = eventMessageConfig?.messageFormat else {
            return message
        }

        message = messageFormat
        for placeholder in placeholders {
            message = message.replacingOccurrences(of: placeholder.key,
                                                   with: placeholder.value.0 ?? placeholder.value.1)
        }
        return message
    }
}

protocol MessageConfig {
    var messageFormat: String { get }
    var requiredPlaceholders: [String] { get }
}

struct SpawnBombDisruptorMessageConfig: MessageConfig {
    var messageFormat: String = "{sourcePlayer} threw a bomb at {targetPlayer}"
    var requiredPlaceholders: [String] = ["{sourcePlayer}", "{targetPlayer}"]
}

struct PlayerDiedMessageConfig: MessageConfig {
    var messageFormat: String = "{sourcePlayer} died"
    var requiredPlaceholders: [String] = ["{sourcePlayer}"]
}

struct AnnounceFeedEvent: Event {
    var timestamp: Double
    var message: String
}
