//
//  MessageHandler.swift
//  PulsePace
//
//  Created by Charisma Kausar on 31/3/23.
//
import Foundation

protocol MessageHandler: AnyObject {
    associatedtype MatchEventType: MatchEvent
    var nextHandler: (any MessageHandler)? { get set }
    static func createHandler() -> Self
    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage)
    func setNext(handler: any MessageHandler) -> any MessageHandler
}

extension MessageHandler {
    func decodeMatchEventMessage(message: MatchEventMessage) -> MatchEventType? {
        guard let data = Data(base64Encoded: message.encodedEvent),
              let matchEvent = try? JSONDecoder().decode(MatchEventType.self, from: data)
        else {
            return nil
        }
        return matchEvent
    }

    func setNext(handler: any MessageHandler) -> any MessageHandler {
        self.nextHandler = handler
        return handler
    }
}
