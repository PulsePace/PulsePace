//
//  MatchEventRelay.swift
//  PulsePace
//
//  Created by James Chiu on 2/4/23.
//

import Foundation

protocol MatchEventRelay: ModeSystem {
    var match: Match? { get set }
    var userId: String? { get set }
    var publisher: ((MatchEventMessage) -> Void)? { get set }
}

extension MatchEventRelay {
    func assignProperties(userId: String, publisher: @escaping (MatchEventMessage) -> Void, match: Match) {
        self.match = match
        self.userId = userId
        self.publisher = publisher
    }

    func reset() {
        match = nil
        userId = nil
        publisher = nil
    }
}

class CoopMatchEventRelay: MatchEventRelay {
    var match: Match?
    var userId: String?
    var publisher: ((MatchEventMessage) -> Void)?

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(missEventRelay)
    }

    private lazy var missEventRelay = { [weak self] (_: EventManagable, missEvent: MissEvent) -> Void in
        guard let self = self, let userId = self.userId else {
            fatalError("No active match event relay")
        }
        guard let matchEventMessage = MissEvent.makeMessage(event: missEvent, playerId: userId) else {
            return
        }
        self.publisher?(matchEventMessage)
    }
}

class CompetitiveMatchEventRelay: MatchEventRelay {
    var match: Match?
    var userId: String?
    var publisher: ((MatchEventMessage) -> Void)?

    func registerEventHandlers(eventManager: EventManagable) {
        eventManager.registerHandler(otherRelay)
    }

    private lazy var otherRelay = { [weak self] (_: EventManagable, _: DeathEvent) -> Void in
        guard let self = self, let userId = self.userId else {
            fatalError("No active match event relay")
        }
        print(self.publisher ?? "") // TODO: MatchEvents - `makeMessage()` can be done by the other system
    }
}
