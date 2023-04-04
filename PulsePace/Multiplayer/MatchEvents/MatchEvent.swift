//
//  MatchEvent.swift
//  PulsePace
//
//  Created by Charisma Kausar on 31/3/23.
//

import Foundation

protocol MatchEvent: Codable {
    var timestamp: Double { get }
}

// Coop limited to two player
struct PublishMissTapEvent: MatchEvent {
    var timestamp: Double
    var tapHO: SerializedTapHO
    var destinationId: String
}

struct PublishMissSlideEvent: MatchEvent {
    var timestamp: Double
    var slideHO: SerializedSlideHO
    var destinationId: String
}

struct PublishMissHoldEvent: MatchEvent {
    var timestamp: Double
    var holdHO: SerializedHoldHO
    var destinationId: String
}

struct PublishBombDisruptorEvent: MatchEvent {
    var timestamp: Double
    var bombTargetId: String
    var bombLocation: CGPoint
}

struct PublishNoHintsDisruptorEvent: MatchEvent {
    var timestamp: Double
    var noHintsTargetId: String
    var preSpawnInterval: Double
    var duration: Double
}

struct PublishDeathEvent: MatchEvent {
    var timestamp: Double
    var diedPlayerId: String
}

// Events
struct SpawnBombDisruptorEvent: Event {
    var timestamp: Double
    var bombSourcePlayerId: String
    var bombTargetPlayerId: String
    var bombLocation: CGPoint
}

struct ActivateNoHintsDisruptorEvent: Event {
    var timestamp: Double
    var noHintsSourcePlayerId: String
    var noHintsTargetPlayerId: String
    var preSpawnInterval: Double
    var duration: Double
}

struct DeactivateNoHintsDisruptorEvent: Event {
    var timestamp: Double
    var noHintsTargetPlayerId: String
}

struct UpdateComboEvent: Event {
    var timestamp: Double
    var comboCount: Int
    var lastLocation: CGPoint
}

struct SpawnHOEvent: Event {
    var timestamp = 0.0
    var hitObject: any HitObject
}

struct DeathEvent: Event {
    var timestamp: Double
    var diedPlayerId: String
}

struct LostLifeEvent: Event {
    var timestamp: Double
    var lostLifePlayerId: String
}
