//
//  HitEvent.swift
//  PulsePace
//
//  Created by Yuanxi Zhu on 26/3/23.
//

import Foundation

struct NoEvent: Event {
    let timestamp = 0.0
}

struct LastHitObjectRemovedEvent: Event {
    var timestamp: Double
}

struct HitEvent: Event {
    var timestamp: Double
    var gameHO: any GameHO
}

struct MissEvent: Event {
    var timestamp: Double
    var gameHO: any GameHO
}

struct LostLifeEvent: Event {
    var timestamp: Double
}

extension MissEvent: MatchRelatedEvent {
    static func makeMessage(event: MissEvent, playerId: String) -> MatchEventMessage? {
        if event.gameHO.fromPartner {
            return nil
        }

        let timeStamp = Date().timeIntervalSince1970
        if let tapGameHO = event.gameHO as? TapGameHO {
            return MatchEventMessage(
                timestamp: timeStamp,
                sourceId: playerId,
                event: PublishMissTapEvent(timestamp: timeStamp,
                                           tapHO: SerializedTapHO(tapGameHO: tapGameHO),
                                           sourceId: playerId))
        } else if let slideGameHO = event.gameHO as? SlideGameHO {
            return MatchEventMessage(
                timestamp: timeStamp,
                sourceId: playerId,
                event: PublishMissSlideEvent(timestamp: timeStamp,
                                             slideHO: SerializedSlideHO(slideGameHO: slideGameHO),
                                             sourceId: playerId))
        } else if let holdGameHO = event.gameHO as? HoldGameHO {
            return MatchEventMessage(
                timestamp: timeStamp,
                sourceId: playerId,
                event: PublishMissHoldEvent(timestamp: timeStamp,
                                            holdHO: SerializedHoldHO(holdGameHO: holdGameHO),
                                            sourceId: playerId))
        } else {
            print("Unsupported game hit object type")
            return nil
        }
    }
}

struct GameCompleteEvent: Event {
    var timestamp: Double
    var finalScore: Int
}

extension GameCompleteEvent: MatchRelatedEvent {
    static func makeMessage(event: GameCompleteEvent, playerId: String) -> MatchEventMessage? {
        let timeStamp = Date().timeIntervalSince1970
        return MatchEventMessage(
            timestamp: timeStamp,
            sourceId: playerId,
            event: PublishGameCompleteEvent(timestamp: timeStamp,
                                            sourceId: playerId, finalScore: event.finalScore))
    }
}

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
    var score: Int
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

extension SelfDeathEvent: MatchRelatedEvent {
    static func makeMessage(event: SelfDeathEvent, playerId: String) -> MatchEventMessage? {
        MatchEventMessage(timestamp: event.timestamp, sourceId: playerId,
                          event: PublishDeathEvent(timestamp: event.timestamp, diedPlayerId: playerId))
    }
}

struct OnlyRemainingPlayerEvent: Event {
    var timestamp: Double
}

struct UpdateScoreEvent: Event {
    var timestamp: Double
    var playerScore: Int
    var playerId: String
}
