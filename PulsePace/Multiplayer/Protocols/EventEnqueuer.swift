//
//  EventEnqueuer.swift
//  PulsePace
//
//  Created by Charisma Kausar on 31/3/23.
//

protocol EventEnqueuer {
    func addToEventQueue(eventManager: EventManagable, message: MatchEventMessage)
}
