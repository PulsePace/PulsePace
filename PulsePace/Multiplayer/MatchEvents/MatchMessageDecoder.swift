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

class SampleMessageDecoder: MessageHandler {
    var nextHandler: MessageHandler?

    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage) {
        guard let data = Data(base64Encoded: message.encodedEvent),
              let event = try? JSONDecoder().decode(SampleEvent.self, from: data)
        else {
            nextHandler?.addMessageToEventQueue(eventManager: eventManager, message: message)
            return
        }
        print(event)
        print("sample event")
    }
}

class BombDisruptorMessageDecoder: MessageHandler {
    var nextHandler: MessageHandler?

    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage) {
        guard let data = Data(base64Encoded: message.encodedEvent),
              let event = try? JSONDecoder().decode(PublishBombDisruptorEvent.self, from: data)
        else {
            print("end of CoR")
            return
        }
        print(event)
        eventManager.add(event: SpawnBombDisruptorEvent(timestamp: Date().timeIntervalSince1970))
        eventManager.add(event: AnnounceFeedEvent(timestamp: Date().timeIntervalSince1970,
                                                  message: "Bomb spawned for \( event.destinationIds)"))
        print("bomb disruptor event")
    }
}
