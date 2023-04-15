//
//  MatchEvent.swift
//  PulsePace
//
//  Created by Charisma Kausar on 31/3/23.
//

import Foundation

// NOTE: Assumes one to one relationship between match event and handler
protocol MatchEvent: Codable {
    associatedtype MessageHandlerType: MessageHandler
    var timestamp: Double { get }
}

extension MatchEvent {
    static var getType: MessageHandlerType.Type {
        MessageHandlerType.self
    }
}

// Not used for base decoder dummy
struct PublishNoEvent: MatchEvent {
    typealias MessageHandlerType = MatchMessageDecoder
    var timestamp: Double
}

// Coop limited to two player
// Game complete != Game end in coop context game complete indicate one side has finished all possible gameplay
struct PublishGameCompleteEvent: MatchEvent {
    typealias MessageHandlerType = GameCompleteMessageDecoder
    var timestamp: Double
    var sourceId: String
    var finalScore: Int
}

struct PublishMissTapEvent: MatchEvent {
    typealias MessageHandlerType = MissTapMessageDecoder
    var timestamp: Double
    var tapHO: SerializedTapHO
    var sourceId: String
}

struct PublishMissSlideEvent: MatchEvent {
    typealias MessageHandlerType = MissSlideMessageDecoder
    var timestamp: Double
    var slideHO: SerializedSlideHO
    var sourceId: String
}

struct PublishMissHoldEvent: MatchEvent {
    typealias MessageHandlerType = MissHoldMessageDecoder
    var timestamp: Double
    var holdHO: SerializedHoldHO
    var sourceId: String
}

struct PublishBombDisruptorEvent: MatchEvent {
    typealias MessageHandlerType = BombDisruptorMessageDecoder
    var timestamp: Double
    var bombTargetId: String
    var bombLocation: CGPoint
}

struct PublishNoHintsDisruptorEvent: MatchEvent {
    typealias MessageHandlerType = NoHintsDisruptorMessageDecoder
    var timestamp: Double
    var noHintsTargetId: String
    var preSpawnInterval: Double
    var duration: Double
}

struct PublishDeathEvent: MatchEvent {
    typealias MessageHandlerType = DeathMessageDecoder
    var timestamp: Double
    var diedPlayerId: String
}

struct PublishScoreEvent: MatchEvent {
    typealias MessageHandlerType = ScoreMessageDecoder
    var timestamp: Double
    var playerScore: Int
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

struct SelfDeathEvent: Event {
    var timestamp: Double
}

struct OnlyRemainingPlayerEvent: Event {
    var timestamp: Double
}

struct UpdateScoreEvent: Event {
    var timestamp: Double
    var playerScore: Int
    var playerId: String
}

extension SelfDeathEvent: MatchRelatedEvent {
    static func makeMessage(event: SelfDeathEvent, playerId: String) -> MatchEventMessage? {
        MatchEventMessage(timestamp: event.timestamp, sourceId: playerId,
                          event: PublishDeathEvent(timestamp: event.timestamp, diedPlayerId: playerId))
    }
}
