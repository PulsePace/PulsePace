//
//  MatchMessageDecoder.swift
//  PulsePace
//
//  Created by Charisma Kausar on 31/3/23.
//

import Foundation

final class SampleMessageDecoder: MessageHandler {
    static func createHandler() -> SampleMessageDecoder {
        SampleMessageDecoder()
    }

    typealias MatchEventType = SampleEvent
    var nextHandler: (any MessageHandler)?

    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage) {
        guard let matchEvent = decodeMatchEventMessage(message: message) else {
            nextHandler?.addMessageToEventQueue(eventManager: eventManager, message: message)
            return
        }
        print(matchEvent)
        print("sample event")
    }
}

final class BombDisruptorMessageDecoder: MessageHandler {
    static func createHandler() -> BombDisruptorMessageDecoder {
        BombDisruptorMessageDecoder()
    }

    typealias MatchEventType = PublishBombDisruptorEvent
    var nextHandler: (any MessageHandler)?

    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage) {
        guard let matchEvent = decodeMatchEventMessage(message: message) else {
            print("end of CoR")
            return
        }
        eventManager.add(event: SpawnBombDisruptorEvent(timestamp: Date().timeIntervalSince1970,
                                                        bombSourcePlayerId: message.sourceId,
                                                        bombTargetPlayerId: matchEvent.destinationIds[0]))
        print("bomb disruptor event")
    }
}

final class MissTapMessageDecoder: MessageHandler {
    static func createHandler() -> MissTapMessageDecoder {
        MissTapMessageDecoder()
    }

    typealias MatchEventType = PublishMissTapEvent
    var nextHandler: (any MessageHandler)?

    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage) {
        guard let matchEvent = decodeMatchEventMessage(message: message) else {
            nextHandler?.addMessageToEventQueue(eventManager: eventManager, message: message)
            return
        }
        eventManager.add(event: SpawnHOEvent(timestamp: Date().timeIntervalSince1970,
                                             hitObject: matchEvent.tapHO.deserialize()))
    }
}

final class MissHoldMessageDecoder: MessageHandler {
    static func createHandler() -> MissHoldMessageDecoder {
        MissHoldMessageDecoder()
    }

    typealias MatchEventType = PublishMissHoldEvent
    var nextHandler: (any MessageHandler)?

    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage) {
        guard let matchEvent = decodeMatchEventMessage(message: message) else {
            nextHandler?.addMessageToEventQueue(eventManager: eventManager, message: message)
            return
        }
        eventManager.add(event: SpawnHOEvent(
            timestamp: Date().timeIntervalSince1970,
            hitObject: matchEvent.holdHO.deserialize()
        ))
    }
}

final class MissSlideMessageDecoder: MessageHandler {
    static func createHandler() -> MissSlideMessageDecoder {
        MissSlideMessageDecoder()
    }

    typealias MatchEventType = PublishMissSlideEvent
    var nextHandler: (any MessageHandler)?

    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage) {
        guard let matchEvent = decodeMatchEventMessage(message: message) else {
            nextHandler?.addMessageToEventQueue(eventManager: eventManager, message: message)
            return
        }
        eventManager.add(event: SpawnHOEvent(
            timestamp: Date().timeIntervalSince1970,
            hitObject: matchEvent.slideHO.deserialize()
        ))
    }
}
