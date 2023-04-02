//
//  MatchMessageDecoder.swift
//  PulsePace
//
//  Created by Charisma Kausar on 31/3/23.
//

import Foundation

class MatchMessageDecoder: MessageHandler {
    var nextHandler: MessageHandler?
    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage) {
        nextHandler?.addMessageToEventQueue(eventManager: eventManager, message: message)
    }
}

class BombDisruptorMessageDecoder: MessageHandler {
    var nextHandler: MessageHandler?

    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage) {
        guard let data = Data(base64Encoded: message.encodedEvent),
              let event = try? JSONDecoder().decode(PublishBombDisruptorEvent.self, from: data)
        else {
            nextHandler?.addMessageToEventQueue(eventManager: eventManager, message: message)
            return
        }
        eventManager.add(event: SpawnBombDisruptorEvent(timestamp: Date().timeIntervalSince1970,
                                                        bombSourcePlayerId: message.sourceId,
                                                        bombTargetPlayerId: event.bombTargetId,
                                                        bombLocation: event.bombLocation
                                                       ))
        print("bomb disruptor event")
    }
}

class NoHintsDisruptorMessageDecoder: MessageHandler {
    var nextHandler: MessageHandler?

    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage) {
        guard let data = Data(base64Encoded: message.encodedEvent),
              let event = try? JSONDecoder().decode(PublishNoHintsDisruptorEvent.self, from: data)
        else {
            nextHandler?.addMessageToEventQueue(eventManager: eventManager, message: message)
            return
        }
        eventManager.add(event: ActivateNoHintsDisruptorEvent(timestamp: event.timestamp,
                                                              noHintsSourcePlayerId: message.sourceId,
                                                              noHintsTargetPlayerId: event.noHintsTargetId,
                                                              preSpawnInterval: event.preSpawnInterval,
                                                              duration: event.duration))
        print("no hints disruptor event")
    }
}

class MissTapMessageDecoder: MessageHandler {
    var nextHandler: MessageHandler?

    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage) {
        guard let data = Data(base64Encoded: message.encodedEvent),
              let event = try? JSONDecoder().decode(PublishMissTapEvent.self, from: data) else {
            nextHandler?.addMessageToEventQueue(eventManager: eventManager, message: message)
            return
        }
        eventManager.add(event: SpawnHOEvent(timestamp: Date().timeIntervalSince1970,
                                             hitObject: event.tapHO.deserialize()))
    }
}

class MissHoldMessageDecoder: MessageHandler {
    var nextHandler: MessageHandler?

    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage) {
        guard let data = Data(base64Encoded: message.encodedEvent),
              let event = try? JSONDecoder().decode(PublishMissHoldEvent.self, from: data) else {
            nextHandler?.addMessageToEventQueue(eventManager: eventManager, message: message)
            return
        }
        eventManager.add(event: SpawnHOEvent(
            timestamp: Date().timeIntervalSince1970,
            hitObject: event.holdHO.deserialize()
        ))
    }
}

class MissSlideMessageDecoder: MessageHandler {
    var nextHandler: MessageHandler?

    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage) {
        guard let data = Data(base64Encoded: message.encodedEvent),
              let event = try? JSONDecoder().decode(PublishMissSlideEvent.self, from: data) else {
            nextHandler?.addMessageToEventQueue(eventManager: eventManager, message: message)
            return
        }
        eventManager.add(event: SpawnHOEvent(
            timestamp: Date().timeIntervalSince1970,
            hitObject: event.slideHO.deserialize()
        ))
    }
}
