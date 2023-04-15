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

struct LastHitobjectRemovedEvent: Event {
    var timestamp: Double
}

struct HitEvent: Event {
    var timestamp: Double
    var gameHO: any GameHO

    init(gameHO: any GameHO, timestamp: Double) {
        self.gameHO = gameHO
        self.timestamp = timestamp
    }
}

struct MissEvent: Event {
    var timestamp: Double
    var gameHO: any GameHO

    init(gameHO: any GameHO, timestamp: Double) {
        self.gameHO = gameHO
        self.timestamp = timestamp
    }
}

struct LoseLifeEvent: Event {
    var timestamp: Double

    init(timestamp: Double) {
        self.timestamp = timestamp
    }
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
