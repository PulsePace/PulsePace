//
//  MessageHandler.swift
//  PulsePace
//
//  Created by Charisma Kausar on 31/3/23.
//

protocol MessageHandler: AnyObject {
    var nextHandler: MessageHandler? { get set }
    func addMessageToEventQueue(eventManager: EventManagable, message: MatchEventMessage)
    func setNext(handler: MessageHandler) -> MessageHandler
}

extension MessageHandler {
    func setNext(handler: MessageHandler) -> MessageHandler {
        self.nextHandler = handler
        return handler
    }
}
