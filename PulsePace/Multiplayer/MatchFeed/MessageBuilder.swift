//
//  MessageBuilder.swift
//  PulsePace
//
//  Created by Charisma Kausar on 1/4/23.
//

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

    private var tempPlaceholders: [String: String] = [:]
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

    func setValue(replace oldValue: String, with newValue: String) -> MessageBuilder {
        tempPlaceholders[oldValue] = newValue
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
        for temp in tempPlaceholders {
            message = message.replacingOccurrences(of: temp.key, with: temp.value)
        }
        tempPlaceholders = [:]
        return message
    }
}
