//
//  MessageConfig.swift
//  PulsePace
//
//  Created by Charisma Kausar on 1/4/23.
//

protocol MessageConfig {
    var messageFormat: String { get }
    var requiredPlaceholders: [String] { get }
}

struct SpawnBombDisruptorMessageConfig: MessageConfig {
    var messageFormat: String = "{sourcePlayer} threw a bomb at {targetPlayer}"
    var requiredPlaceholders: [String] = ["{sourcePlayer}", "{targetPlayer}"]
}

struct ActivateNoHintsDisruptorMessageConfig: MessageConfig {
    var messageFormat: String = "{sourcePlayer} took away hints from {targetPlayer}"
    var requiredPlaceholders: [String] = ["{sourcePlayer}", "{targetPlayer}"]
}

struct DeathMessageConfig: MessageConfig {
    var messageFormat: String = "{sourcePlayer} died"
    var requiredPlaceholders: [String] = ["{sourcePlayer}"]
}

struct LostLifeMessageConfig: MessageConfig {
    var messageFormat: String = "{sourcePlayer} lost a life"
    var requiredPlaceholders: [String] = ["{sourcePlayer}"]
}
